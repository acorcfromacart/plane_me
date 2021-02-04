import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:plane_me/archiveNotes/archived_notes.dart';
import 'package:plane_me/profileScreen/profile_screen.dart';
import 'package:plane_me/screens/googleSignIn/allNotesScreen/all_notes.dart';
import 'package:plane_me/todoScreens/todo_list.dart';

import 'main_screen.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int pageIndex = 0;

  //Creating pages
  final MainScreen _mainScreen = MainScreen();
  final AllNotesScreen _listOfNotes = AllNotesScreen();
  final TodoScreen _todoScreen = TodoScreen();
  final ProfileScreen _profileScreen = ProfileScreen();

  Widget _showPage = new MainScreen();

  GlobalKey _bottomNavigationKey = GlobalKey();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _mainScreen;
        break;
      case 1:
        return _listOfNotes;
        break;
      case 2:
        return _todoScreen;
        break;
      case 3:
        return _profileScreen;
        break;
      default:
        return new Container(
          child: Center(
            child: Text(
              'Sem página para escolher',
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          initialIndex: pageIndex,
          key: _bottomNavigationKey,
          items: <Widget>[
            Icon(Icons.home, size: 30,color: Colors.white,),
            Icon(Icons.list, size: 30,color: Colors.white,),
            Icon(Icons.done_all_rounded, size: 30, color: Colors.white,),
            Icon(Icons.person, size: 30,color: Colors.white,),
          ],
          onTap: (int tappedIndex) {
            setState(() {
              _showPage = _pageChooser(tappedIndex);
            });
          },
          color: Colors.white24,
          backgroundColor: Colors.black,
          buttonBackgroundColor: Colors.deepOrangeAccent,
        ),
        body: Container(
          color: Colors.black54,
          child: Center(
            child: _showPage,
          ),
        ));
  }
}