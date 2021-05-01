import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plane_me/models/auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
User user;

int active = 0;
int created = 0;
int done = 0;
String statisticsId;

Future<String> checkCredentials() async {
  try {
    await firestore.doc('users/$userId').get().then((doc) {
      if (doc.exists) {
        print('Usuário localizado no Firestore');
      } else {
        Future.delayed(Duration(seconds: 5), () {
          addUserToCollection();
        });
      }
    });
  } catch (e) {
    print('$e + ESSE É UM ERRO AO VERIFICAR AS CREDENCIAIS DO USUÁRIO');
  }
  return null;
}

Future<String> checkStatisticExistence() async {
  try {
    firestore
        .doc('users/$userId')
        .collection('statistics')
        .snapshots()
        .listen((event) {
      if (event.docs.length == 0) {
        addStatisticsExistence();
      } else {
        print('********* o documento existe *********');
        event.docs.forEach((result) {
          statisticsId = result.id;
        });
      }
    });
  } catch (e) {
    print(e.toString());
  }
  return null;
}

Future<String> addStatisticsExistence() async {
  firestore.collection('users').doc(userId).collection('statistics').add({
    'created': 0,
    'done': 0,
  });
  return null;
}

Future<String> addUserToCollection() async {
  firestore.collection('users').doc(userId).set({'userUid': userId});
  return null;
}

Future<QuerySnapshot> readAllNotes() async {
  Stream<QuerySnapshot> a = firestore
      .doc('users/$userId')
      .collection('calendarEvents')
      .where('archieve', isEqualTo: false)
      .snapshots();

  return a.first;
}

Future<QuerySnapshot> readAllArchivedNotes() async {
  Stream<QuerySnapshot> a = firestore
      .doc('users/$userId')
      .collection('calendarEvents')
      .where('archieve', isEqualTo: true)
      .snapshots();
  return a.first;
}

Future<String> countAllNotes() async {
  firestore
      .doc('users/$userId')
      .collection('calendarEvents')
      .where('archieve', isEqualTo: false)
      .snapshots()
      .listen((event) {
    active = event.docs.length;
  });
  return null;
}

Future<String> doneNotes() async {
  await firestore
      .doc('users/$userId')
      .collection('statistics')
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((element) {
      print(element.data());

      if (element != null) {
        done = element.data()['done'];
        created = element.data()['created'];
      } else {
        done = 0;
        created = 0;
      }
    });
  });
  return null;
}
