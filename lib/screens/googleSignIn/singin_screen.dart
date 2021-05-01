import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:plane_me/models/auth.dart';
import 'package:plane_me/translation/localizations.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            FadeIn(
              child: Image.asset(
                'images/icon.png',
              ),
              duration: Duration(seconds: 3),
              curve: Curves.easeIn,
            ),
            FadeIn(
              child: Text(
                'planMe',
                style: TextStyle(
                  fontSize: 60,
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                ),
              ),
              duration: Duration(seconds: 5),
              curve: Curves.easeIn,
            ),
            FadeIn(
              child: Text(
                AppLocalizations.instance.translate("sign_in_desc"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              duration: Duration(seconds: 7),
              curve: Curves.easeIn,
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: FadeIn(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: InkWell(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffff7400),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15)),
                          ),
                          onPressed: () async {
                            /// Trying to login with Google
                            signInWithGoogle(context).then((result) {
                              if (userId != null) {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                'images/google_logo.png',
                                width: 52,
                                height: 52,
                              ),
                              Expanded(
                                child: Text(
                                  AppLocalizations.instance
                                      .translate("sign_in_bt"),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 21),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    duration: Duration(seconds: 9),
                    curve: Curves.easeIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
