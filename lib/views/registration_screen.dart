import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/views/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  void initState() {
    super.initState();
    Firebase.initializeApp();
    final firestoreInstance = FirebaseFirestore.instance;

    firestoreInstance.collection("country").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data()['code']);
      });
    });
  }

  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainDarkColor,
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Color(0xFF0B1724FF),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: Container(
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: kWelcomeScreenTitleText),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: kMainLightColor, width: 1),
                    ),
                    hintStyle: TextStyle(color: kMainLightColor),
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: kMainLightColor),
                    hintText: 'Enter valid email, e.g. abc@mail.com'),
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide:
                          const BorderSide(color: kMainLightColor, width: 1),
                    ),
                    hintStyle: TextStyle(color: kMainLightColor),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: kMainLightColor),
                    hintText: 'Enter secure password'),
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, LoginScreen.id),
                child: Text(
                  'Already have an account? Log in here!',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
            ),
            Container(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kMainMediumColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 105.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Register',
                        style:
                            TextStyle(fontSize: 20.0, color: kMainLightColor),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ProfileScreen.id);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}