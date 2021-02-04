import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plane_me/models/auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
User user;


Future<QuerySnapshot> readAllToDos() async {
  Stream<QuerySnapshot> notes = firestore
      .doc('users/$userId')
      .collection('ToDo')
  .orderBy('done', descending: false)
      .snapshots();

  return notes.first;
}
