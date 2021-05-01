import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plane_me/models/user_notes.dart';
import 'package:plane_me/screens/googleSignIn/validationScreen/validation.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignInAccount currentUser;
String imageUrl;
String name;
String userId;

final GoogleSignIn googleSignIn = GoogleSignIn();
User user = _auth.currentUser;

Future<String> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    final User user = authResult.user;

    assert(user.uid != null);
    userId = user.uid;
    imageUrl = user.photoURL.toString();
    name = user.displayName.toString();
  } catch (error) {
    print('$error + Esse é o erro ao entrar com o Google');
  }
}

Future<String> checkingCurrentUser(BuildContext context) async {
  googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    currentUser = account;
    userId = user.uid;

    if (currentUser != null) {
      imageUrl = currentUser.photoUrl.toString();
      name = currentUser.displayName.toString();
      doneNotes();
      countAllNotes();
      checkCredentials();
      checkStatisticExistence();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      getCurrentUser(context);
    }
  });
  googleSignIn.signInSilently();
}

Future<void> signOuWithGoogle(BuildContext context) async {
  _auth.signOut().then((value) {
    googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, '/signIn');
  });
}

Future<User> getCurrentUser(BuildContext context) async {
  user = _auth.currentUser;
  if (user == null) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/signIn');
    });
  }
}
