import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:plane_me/models/auth.dart';
import 'package:plane_me/models/event.dart';
import 'package:plane_me/models/event_firestore_service.dart';
import 'package:plane_me/models/user_notes.dart';
import 'package:plane_me/screens/googleSignIn/mainScreen/note_details.dart';
import 'package:plane_me/translation/localizations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';


class MainScreen extends StatefulWidget {
  final EventModel note;

  const MainScreen({Key key, this.note}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  GlobalKey _bottomNavigationKey = GlobalKey();
  bool enableSwitch = false;

  void _toggle() {
    setState(() {
      enableSwitch = !enableSwitch;
    });
  }

  CalendarController controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  var now = DateTime.now();
  var t = TimeOfDay.now();

  PanelController _pc = new PanelController();
  bool status = false;
  bool checkedValue = false;
  bool processing;

  final double _initFabHeight = 140.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 0.0;


  TextEditingController _timeController = TextEditingController();

  /// Implementing upload note to firebase
  TextEditingController _title;
  TextEditingController _description;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  final spinkit = SpinKitSquareCircle(
    color: Colors.white,
    size: 50.0,
  );

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
    _fabHeight = _initFabHeight;
    processing = false;
    _title = TextEditingController(
        text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
    _events = {};
    _selectedEvents = [];
    doneNotes();
    checkingCurrentUser(context);
    checkCredentials();
    checkStatisticExistence();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller = CalendarController();
  }

  calendar() {
    return StreamBuilder<List<EventModel>>(
      stream: eventDBS.streamList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<EventModel> allEvents = snapshot.data;
          if (allEvents.isNotEmpty) {
            _events = _groupEvents(allEvents);
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              events: _events,
              calendarController: controller,
              formatAnimation: FormatAnimation.slide,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                eventDayStyle: TextStyle(color: Colors.orange),
                weekdayStyle: TextStyle(color: Colors.white),
                outsideDaysVisible: false,
                canEventMarkersOverflow: false,
                selectedColor: Colors.white,
                todayColor: Colors.orange,
                markersColor: Colors.yellowAccent,
                todayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white),
              ),
              headerStyle: HeaderStyle(
                leftChevronIcon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                ),
                rightChevronIcon: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                ),
                centerHeaderTitle: true,
                titleTextStyle: TextStyle(color: Colors.deepOrangeAccent),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events, holidays) {
                setState(() {
                  _selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                todayDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            ..._selectedEvents.map(
              (event) => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NoteDetails(
                                      event: event,
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(21.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      event.title,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    DateFormat('kk:mm').format(event.eventDate),
                                    //overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                event.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Row(
                              //       children: [
                              //         CircleAvatar(
                              //           radius: 24,
                              //           child: ClipOval(
                              //             child: Image.network(
                              //               imageUrl,
                              //               width: 120,
                              //               height: 120,
                              //             ),
                              //           ),
                              //         ),
                              //         SizedBox(
                              //           width: 6,
                              //         ),
                              //         CircleAvatar(
                              //           radius: 24,
                              //           child: ClipOval(
                              //             child: Image.network(
                              //               imageUrl,
                              //               width: 120,
                              //               height: 120,
                              //             ),
                              //           ),
                              //         ),
                              //         SizedBox(
                              //           width: 6,
                              //         ),
                              //         CircleAvatar(
                              //           radius: 24,
                              //           child: ClipOval(
                              //             child: Image.network(
                              //               imageUrl,
                              //               width: 120,
                              //               height: 120,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     ToggleSwitch(
                              //       minWidth: 50.0,
                              //       minHeight: 30,
                              //       initialLabelIndex: 1,
                              //       cornerRadius: 20.0,
                              //       activeFgColor: Colors.white,
                              //       inactiveBgColor: Colors.grey,
                              //       inactiveFgColor: Colors.white,
                              //       labels: ['', ''],
                              //       icons: [Icons.close, Icons.share_sharp],
                              //       activeBgColors: [Colors.black38, Colors.black],
                              //       onToggle: (index) {
                              //         print('switched to: $index');
                              //       },
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showDateAndTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        DateFormat('EEEE, d MMM, yyyy').format(now),
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            letterSpacing: 1),
        overflow: TextOverflow.ellipsis,
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
      key: _key,
      backgroundColor: Colors.transparent,
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20.0,
                  color: Colors.white30,
                ),
              ]),
          margin: const EdgeInsets.all(12.0),
          child: processing
              ? loading()
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pc.close();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                AppLocalizations.instance.translate("title"),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextFormField(
                              controller: _title,
                              maxLength: 32,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  hintText: AppLocalizations.instance.translate("hint_type_1"),
                                  hintStyle:
                                      TextStyle(color: Colors.grey[800])),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.normal,
                              ),
                              validator: (value) => (value.isEmpty)
                                  ? AppLocalizations.instance.translate("title_forget")

                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                AppLocalizations.instance.translate("description"),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextFormField(
                              controller: _description,
                              maxLines: null,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  hintText: AppLocalizations.instance.translate("hint_type_2"),
                                  hintStyle:
                                      TextStyle(color: Colors.grey[800])),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.normal,
                              ),
                              validator: (value) =>
                                  (value.isEmpty) ? AppLocalizations.instance.translate("desc_forget") : null,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          showDate(),
                          SizedBox(
                            height: 8,
                          ),
                          showTime(),
                          Divider(),
                          SizedBox(
                            height: 12,
                          ),
                          //sharableSelected(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 52,
                        child: RaisedButton(
                          color: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              Future.delayed(Duration(seconds: 4), () {
                                if (widget.note != null) {
                                  eventDBS.updateData(widget.note.id, {
                                    'title': _title.text,
                                    'description': _description.text,
                                    'event_date': widget.note.eventDate,
                                    'shareable': checkedValue,
                                  });
                                } else {
                                  eventDBS.createItem(
                                    EventModel(
                                        title: _title.text,
                                        description: _description.text,
                                        eventDate: now.add(Duration(
                                            hours: t.hour, minutes: t.minute)),
                                        shareable: checkedValue,
                                        archieve: false),
                                  );
                                  statisticsDBS.updateData(statisticsId, {
                                    'created': FieldValue.increment(1),
                                  });
                                }
                                setState(() {
                                  processing = false;
                                  _title.clear();
                                  _description.clear();
                                  _pc.close();
                                });
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            AppLocalizations.instance.translate("save_note")
                            ,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  loading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.instance.translate("saving")
            ,
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

  topBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              return null;
            },
            child: CircleAvatar(
              radius: 21,
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 120,
                  height: 120,
                ),
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
                AppLocalizations.instance.translate("time")
                ,
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

  sharableSelected() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.instance.translate("share")
            ,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          ToggleSwitch(
            minWidth: 50.0,
            minHeight: 30,
            initialLabelIndex: 1,
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            labels: ['', ''],
            icons: [Icons.close, Icons.share_sharp],
            activeBgColors: [Colors.black38, Colors.deepOrangeAccent],
            onToggle: (index) {
              print('switched to: $index');
            },
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: ListView(
                children: [
                  topBarWidget(),
                  SizedBox(
                    height: 6,
                  ),
                  userName(),
                  SizedBox(
                    height: 6,
                  ),
                  showDateAndTime(),
                  SizedBox(
                    height: 6,
                  ),
                  Divider(
                    color: Colors.grey.withAlpha(70),
                  ),
                  calendar(),
                ],
              ),
            ),
            slidingPage(),
          ],
        ),
      ),
    );
  }
}

userName() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Align(
      alignment: Alignment.topLeft,
      child: Text(
        name,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1),
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
