import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plane_me/IntroSlide/slide_screen.dart';
import 'package:plane_me/models/auth.dart';
import 'package:plane_me/models/user_notes.dart';
import 'package:plane_me/translation/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidationScreen extends StatefulWidget {
  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen>
    with TickerProviderStateMixin {
  Future<Widget> checkIsFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime');

    // check is null or true
    if (isFirstTime == null || isFirstTime) {
      prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IntroScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentUser(context);
      checkingCurrentUser(context);
      countAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitSquareCircle(
      color: Colors.white,
      size: 50.0,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.instance.translate("validation_text"),
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            height: 32,
          ),
          spinkit,
        ],
      ),
    );
  }
}
