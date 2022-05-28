import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/models/admin.dart';

class AdminScreen extends StatefulWidget {
  static const String id = 'admin_screen';
  Admin admin = Admin();

  AdminScreen({Key? key}) : super(key: key);
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainDarkColor,
      appBar: AppBar(
        title: Text("Admin"),
        backgroundColor: Color(0xFF0B1724FF),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextButton(
            onPressed: () {
              widget.admin.QuestionsScorersByCompetitionSeason();
            },
            child: Text('Insert questions'),
          )),
    );
  }
}
