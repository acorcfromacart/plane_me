import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:intl/intl.dart';
import 'package:plane_me/models/event_firestore_service.dart';
import 'package:plane_me/models/user_notes.dart';
import 'package:plane_me/screens/googleSignIn/allNotesScreen/all_notes_detail.dart';
import 'package:plane_me/translation/localizations.dart';

class ArchivedNotes extends StatefulWidget {
  @override
  _ArchivedNotesState createState() => _ArchivedNotesState();
}

class _ArchivedNotesState extends State<ArchivedNotes> {
  var now = DateTime.now();


  topHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                AppLocalizations.instance.translate("title_archived_notes"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  retrieveTasks() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
          stream: readAllArchivedNotes().asStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        child: Image.asset(
                          'images/archive_img.png',
                          width: 210,
                          height: 210,
                        ),
                        duration: Duration(seconds: 1),
                        curve: Curves.easeIn,
                      ),
                      FadeIn(
                        child: Text(
                          AppLocalizations.instance
                              .translate("archived"),
                          style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu'),
                        ),
                        duration: Duration(seconds: 1),
                        curve: Curves.easeIn,
                      ),
                    ],
                  );
                }

            // if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            //   return Center(
            //     child: Image.asset('images/archive_img.png')
            //   );
            // }

            return ListView(
              padding: EdgeInsets.only(bottom: 100),
              physics: const AlwaysScrollableScrollPhysics(), // new
              shrinkWrap: true,
              children: snapshot.data.docs.map((document) {
                Timestamp t = document['event_date'];

                return Dismissible(
                  key: Key(
                    document.id,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        print(document.id);
                        print(document['title']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AllNotesDetails(
                                      id: document.id,
                                      title: document['title'],
                                      desc: document['description'],
                                      time: document['event_date'],
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  width: 42,
                                  height: 42,
                                  child: Center(
                                    child: Text(
                                      DateFormat('dd').format(t.toDate()),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        document['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        document['description'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 18,
                                        ),
                                      ),
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
                      final bool res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                AppLocalizations.instance
                                    .translate("delete_warning"),
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    AppLocalizations.instance
                                        .translate("cancel"),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    AppLocalizations.instance
                                        .translate("delete_forever"),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    // TODO: Delete the item from DB etc..
                                    setState(() {
                                      eventDelete
                                          .removeItem(document.id);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                      return res;
                    } else {
                      setState(() {
                        eventDBS.updateData(document.id, {
                          'archieve': false,
                        });
                        statisticsDBS.updateData(
                            statisticsId, {'done': FieldValue.increment(-1)});
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
                Icons.save,
                color: Colors.white,
              ),
              Text(
                AppLocalizations.instance.translate("send_back"),
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
                Icons.delete_forever,
                color: Colors.white,
              ),
              Text(
                AppLocalizations.instance.translate("delete_forever"),
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
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    retrieveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: [
            SizedBox(
              height: 21,
            ),
            topHeader(),
            SizedBox(
              height: 6,
            ),
            showDateAndTime(),
            SizedBox(
              height: 6,
            ),
            retrieveTasks(),
          ],
        ),
      ),
    );
  }
}
