import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:plane_me/models/event_firestore_service.dart';
import 'package:plane_me/screens/googleSignIn/allNotesScreen/all_notes_edit.dart';
import 'package:plane_me/translation/localizations.dart';

class AllNotesDetails extends StatefulWidget {
  final String id;
  final String title;
  final String desc;
  final Timestamp time;

  const AllNotesDetails({Key key, this.id, this.title, this.desc, this.time})
      : super(key: key);

  @override
  _AllNotesDetailsState createState() => _AllNotesDetailsState();
}

class _AllNotesDetailsState extends State<AllNotesDetails> {
  topBarWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
          ),
          Row(
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
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showAnimatedDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return ClassicGeneralDialogWidget(
                            titleText:
                                AppLocalizations.instance.translate("sure"),
                            contentText: AppLocalizations.instance
                                .translate("delete_warning"),
                            positiveText:
                                AppLocalizations.instance.translate("delete"),
                            negativeText:
                                AppLocalizations.instance.translate("cancel"),
                            onPositiveClick: () {
                              eventDelete.removeItem(widget.id);
                              Navigator.of(context).pop();
                              Navigator.pushReplacementNamed(
                                  context, '/allNotes');
                            },
                            onNegativeClick: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        animationType: DialogTransitionType.slideFromBottom,
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(seconds: 1),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 8,
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
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AllNotesEdit(
                                        id: widget.id,
                                        title: widget.title,
                                        description: widget.desc,
                                      )));

                          // Navigator.of(context).pushReplacementNamed('/editNote');
                        })),
              ),
            ],
          ),
        ],
      ),
    );
  }

  titleNote() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Ubuntu',
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  dateNote() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          DateFormat('dd MMM, yyyy').format(widget.time.toDate()),
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            fontFamily: 'Ubuntu',
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  descNote() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.desc,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w300,
            fontFamily: 'Ubuntu',
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: [
            topBarWidget(),
            SizedBox(
              height: 20,
            ),
            titleNote(),
            SizedBox(
              height: 20,
            ),
            dateNote(),
            SizedBox(
              height: 20,
            ),
            descNote(),
          ],
        ),
      ),
    );
  }
}
