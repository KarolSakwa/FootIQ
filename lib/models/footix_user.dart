import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:footix/models/database.dart';

class FootixUser {
  String? email;
  final firestoreInstance = FirebaseFirestore.instance;
  final db = DB();

  FootixUser({this.email})

  //
  // getUserData() {
  //   db.getCollectionData('users')
  // }

}
