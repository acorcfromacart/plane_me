import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:plane_me/models/event_firestore_service.dart';
import 'package:plane_me/todoScreens/todo_event.dart';
import 'package:plane_me/todoScreens/user_todos.dart';
import 'package:plane_me/translation/localizations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var now = DateTime.now();
  var t = TimeOfDay.now();

  bool isDoneOrNot = false;

  PanelController _pc = new PanelController();
  bool status = false;
  bool checkedValue = false;
  bool processing;

  final double _initFabHeight = 140.0;
  // ignore: unused_field
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 0.0;

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController _title = TextEditingController();

  final spinkit = SpinKitSquareCircle(
    color: Colors.white,
    size: 50.0,
  );

  topHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              AppLocalizations.instance.translate("tasks"),
              style: TextStyle(
                fontSize: 34,
                color: Colors.white,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withAlpha(60),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                width: 42,
                height: 42,
                child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _pc.open();
                    })),
          ),
        ],
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: t,
        builder: (BuildContext context, child) {
          return Theme(data: ThemeData.dark(), child: child);
        });
    if (picked != null)
      setState(() {
        t = picked;
        print(t);
      });
  }

  showDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.instance.translate("date"),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    "${now.day} - ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${now.month} - ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${now.year}",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        MaterialButton(
          onPressed: () async {
            DateTime picked = await showDatePicker(
                context: context,
                initialDate: now,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 5),
                builder: (BuildContext context, child) {
                  return Theme(data: ThemeData.dark(), child: child);
                });
            if (picked != null) {
              setState(() {
                now = picked;
                print(now);
              });
            }
          },
          color: Colors.deepOrangeAccent,
          textColor: Colors.white,
          child: Icon(
            Icons.calendar_today_outlined,
          ),
          padding: EdgeInsets.all(12),
          shape: CircleBorder(),
        ),
      ],
    );
  }

  showTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.instance.translate("time"),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    "${t.hour} : ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${t.minute}",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        MaterialButton(
          onPressed: () async {
            _selectTime(context);
          },
          color: Colors.deepOrangeAccent,
          textColor: Colors.white,
          child: Icon(
            Icons.alarm,
          ),
          padding: EdgeInsets.all(12),
          shape: CircleBorder(),
        ),
      ],
    );
  }

  loading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.instance.translate("saving"),
            style: TextStyle(fontSize: 21, color: Colors.white),
          ),
          SizedBox(
            height: 16,
          ),
          spinkit,
        ],
      ),
    );
  }

  slidingPage() {
    return SlidingUpPanel(
      controller: _pc,
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      renderPanelSheet: false,
      parallaxOffset: .15,
      panel: _floatingPanel(),
    );
  }

  _floatingPanel() {
    return Scaffold(
        backgroundColor: Colors.grey,
        key: _key,
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 20,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _pc.close();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _title,
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            hintText: 'Digite sua tarefa',
                            hintStyle: TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white30),
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 21,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.normal,
                          ),
                          validator: (value) => (value.isEmpty)
                              ? AppLocalizations.instance
                                  .translate("title_forget_tasks")
                              : null,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          TodoModel toDo =
                              TodoModel(title: _title.text, done: false);

                          // ignore: deprecated_member_use
                          eventTodo.createItem(toDo);
                          setState(() {
                            _title.clear();
                            readAllToDos().asStream();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  showDateAndTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        DateFormat('EEEE, d MMM, yyyy').format(now),
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            letterSpacing: 1),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  showToDos() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
          stream: readAllToDos().asStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeIn(
                    child: Image.asset(
                      'images/empty.png',
                      width: 210,
                      height: 210,
                    ),
                    duration: Duration(seconds: 1),
                    curve: Curves.easeIn,
                  ),
                  FadeIn(
                    child: Text(
                      AppLocalizations.instance.translate("empty_tasks"),
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
                    ),
                    duration: Duration(seconds: 1),
                    curve: Curves.easeIn,
                  ),
                ],
              );
            }
            return ListView(
              padding: EdgeInsets.only(bottom: 200),
              physics: const AlwaysScrollableScrollPhysics(), // new
              shrinkWrap: true,
              children: snapshot.data.docs.map((document) {
                return Dismissible(
                  key: Key(
                    document.id,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   print(isDoneOrNot);
                        // });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ListTile(
                                          leading: CircularCheckBox(
                                            onChanged: null,
                                            value: document['done'],
                                            checkColor: Colors.black,
                                            activeColor:
                                                Colors.deepOrangeAccent,
                                          ),
                                          title: document['done'] == false
                                              ? Text(
                                                  document['todoTitle'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Ubuntu',
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                )
                                              : Text(
                                                  document['todoTitle'],
                                                  style: TextStyle(
                                                      color: Colors.red
                                                          .withOpacity(0.3),
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                          onTap: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              this.setState(() {
                                                if (document['done'] == false) {
                                                  eventTodo
                                                      .updateData(document.id, {
                                                    'done': true,
                                                  });
                                                } else {
                                                  eventTodo
                                                      .updateData(document.id, {
                                                    'done': false,
                                                  });
                                                }
                                              });
                                            } else {
                                              final snackBar = SnackBar(
                                                  content: Text('Nota vazia'));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  background: slideRightBackground(),
                  secondaryBackground: slideLeftBackground(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final snackBar =
                          SnackBar(content: Text('Apagado com sucesso!'));
                      setState(() {
                        todoModelDelete
                            .removeItem(document.id)
                            .whenComplete(() {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      });
                      return;
                    } else {
                      this.setState(() {
                        if (document['done'] == false) {
                          eventTodo.updateData(document.id, {
                            'done': true,
                          });
                        } else {
                          eventTodo.updateData(document.id, {
                            'done': false,
                          });
                        }
                      });
                      return null;
                    }
                  },
                );
              }).toList(),
            );
          }),
    );
  }

  slideRightBackground() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 24,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.check_box,
                color: Colors.white,
              ),
              Text(
                'Marcar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  slideLeftBackground() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                AppLocalizations.instance.translate("delete"),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    processing = false;
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .16;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ListView(
              children: [
                topHeader(),
                showDateAndTime(),
                SizedBox(
                  height: 12,
                ),
                showToDos(),
              ],
            ),
            slidingPage(),
          ],
        ),
      ),
    );
  }
}
