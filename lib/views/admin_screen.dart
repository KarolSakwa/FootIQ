import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/models/admin.dart';

class AdminScreen extends StatefulWidget {
  static const String id = 'admin_screen';

  AdminScreen({Key? key}) : super(key: key);
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  void initState() {
    Admin admin = Admin();
    //admin.insertQuestionsToDB();

    // Future competitions = admin.getCollectionData('competition');
    // competitions.then((val) {
    //   print(val);
    // });
  }

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainDarkColor,
      appBar: AppBar(
        title: Text("Admin"),
        backgroundColor: Color(0xFF0B1724FF),
      ),
      body: Padding(
          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text('')),
    );
  }
}
