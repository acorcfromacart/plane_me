import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plane_me/IntroSlide/slide_screen.dart';
import 'package:plane_me/archiveNotes/archived_notes.dart';
import 'package:plane_me/profileScreen/profile_screen.dart';
import 'package:plane_me/screens/googleSignIn/allNotesScreen/all_notes.dart';
import 'package:plane_me/screens/googleSignIn/edit_note.dart';
import 'package:plane_me/screens/googleSignIn/mainScreen/home.dart';
import 'package:plane_me/screens/googleSignIn/mainScreen/main_screen.dart';
import 'package:plane_me/screens/googleSignIn/mainScreen/note_details.dart';
import 'package:plane_me/screens/googleSignIn/singin_screen.dart';
import 'package:plane_me/screens/googleSignIn/validationScreen/validation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plane_me/translation/localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'planMe',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/validation',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/main':
            return MaterialPageRoute(
              builder: (_) => MainScreen(),
            );
          case '/validation':
            return MaterialPageRoute(
              builder: (_) => ValidationScreen(),
            );
          case '/noteDetails':
            return MaterialPageRoute(
              builder: (_) => NoteDetails(),
            );
          case '/allNotes':
            return MaterialPageRoute(
              builder: (_) => AllNotesScreen(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (_) => Home(),
            );
          case '/editNote':
            return MaterialPageRoute(
              builder: (_) => EditNote(),
            );
          case '/allNotes':
            return MaterialPageRoute(
              builder: (_) => AllNotesScreen(),
            );
          case '/profileScreen':
            return MaterialPageRoute(
              builder: (_) => ProfileScreen(),
            );
          case '/introSlide':
            return MaterialPageRoute(
              builder: (_) => IntroScreen(),
            );
          case '/archivedNotes':
            return MaterialPageRoute(
              builder: (_) => ArchivedNotes(),
            );
          case '/todo':
            return MaterialPageRoute(
              builder: (_) => ArchivedNotes(),
            );
          case '/signIn':
          default:
            return MaterialPageRoute(builder: (_) => SignInScreen());
        }
      },
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('pt', 'BR'),
        const Locale('en', 'CA'),
        const Locale('en', 'AU'),
        const Locale('es', 'MX'),
        const Locale('es', 'ES'),
        const Locale('fr', 'FR'),
        const Locale('ko', 'KO'),
        const Locale('ru', 'RU'),

        // ... other locales the app supports
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
