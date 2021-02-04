import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:plane_me/models/event_firestore_service.dart';
import 'package:plane_me/translation/localizations.dart';

class AllNotesEdit extends StatefulWidget {
  final String id;
  final String title;
  final String description;

  const AllNotesEdit({Key key, this.id, this.title, this.description})
      : super(key: key);

  @override
  _AllNotesEditState createState() => _AllNotesEditState();
}

class _AllNotesEditState extends State<AllNotesEdit> {
  bool processing = false;

  final spinkit = SpinKitSquareCircle(
    color: Colors.white,
    size: 50.0,
  );

  TextEditingController _titleController;
  TextEditingController _descController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.title);
    _descController = TextEditingController(text: widget.description);

    super.initState();
  }

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
                      Icons.save,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        processing = true;
                      });

                      Future.delayed(Duration(seconds: 3), () {
                        eventDBS.updateData(widget.id, {
                          'title': _titleController.text,
                          'description': _descController.text,
                        }).whenComplete(() {
                          Navigator.pushReplacementNamed(context, '/allNotes');
                          setState(() {
                            processing = false;
                          });
                        });
                      });
                    })),
          ),
        ],
      ),
    );
  }

  titleEdit() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            maxLines: null,
            controller: _titleController,
            maxLength: 32,
            cursorColor: Colors.white70,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(border: InputBorder.none),
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  descriptionEdit() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            maxLines: null,
            controller: _descController,
            cursorColor: Colors.white70,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(border: InputBorder.none),
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  loading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.instance.translate("saving"),
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(
          height: 16,
        ),
        spinkit,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black45,
      body: processing == true
          ? loading()
          : ListView(
              children: [
                topBarWidget(),
                titleEdit(),
                descriptionEdit(),
              ],
            ),
    ));
  }
}
