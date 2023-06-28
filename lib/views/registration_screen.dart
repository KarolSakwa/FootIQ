import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/views/dashboard/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:footix/models/firebase_service.dart';
import 'package:country_picker/country_picker.dart';

import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final FirebaseService firebaseService = FirebaseService();
  static const String id = 'registration_screen';
  String nationality = 'Nationality';
  final firestoreInstance = FirebaseFirestore.instance;

  RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    Firebase.initializeApp();
    final firestoreInstance = FirebaseFirestore.instance;

    firestoreInstance.collection("country").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {});
    });
  }

  final _auth = FirebaseAuth.instance;
  String email = '';
  String username = '';
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainDarkColor,
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: const Color(0xFF0B1724FF),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Container(
                    child: kWelcomeScreenTitleText,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextFormField(
                  style: TextStyle(color: kMainLightColor),
                  cursorColor: kMainLightColor,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kMainLightColor, width: 1),
                    ),
                    hintStyle: TextStyle(color: kMainLightColor),
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: kMainLightColor),
                    hintText: 'Enter valid email, e.g. abc@mail.com',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                  style: const TextStyle(color: kMainLightColor),
                  cursorColor: kMainLightColor,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kMainLightColor, width: 1),
                    ),
                    hintStyle: TextStyle(color: kMainLightColor),
                    border: OutlineInputBorder(),
                    labelText: 'Display name',
                    labelStyle: TextStyle(color: kMainLightColor),
                    hintText: 'Enter your public username',
                  ),
                  onChanged: (value) {
                    username = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15,
                  bottom: 0,
                ),
                child: TextFormField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kMainLightColor, width: 1),
                    ),
                    hintStyle: TextStyle(color: kMainLightColor),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: kMainLightColor),
                    hintText: 'Enter secure password',
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15,
                  bottom: 0,
                ),
                child: TextFormField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kMainLightColor, width: 1),
                    ),
                    hintStyle: TextStyle(color: kMainLightColor),
                    border: OutlineInputBorder(),
                    labelText: 'Confirm password',
                    labelStyle: TextStyle(color: kMainLightColor),
                    hintText: 'Repeat password',
                  ),
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  validator: (value) {
                    if (value != password) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
              ),
              FlatButton(
                onPressed: () {
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                },
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, LoginScreen.id),
                  child: const Text(
                    'Already have an account? Log in here!',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kMainMediumColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 105.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Register',
                        style:
                            TextStyle(fontSize: 20.0, color: kMainLightColor),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          )
                          .then(
                            (value) => value.user!.updateDisplayName(username),
                          );
                      widget.firebaseService.addData(
                        'users',
                        {
                          'email': email,
                          'name': username,
                          'answeredQuestions': {},
                          'ID': _auth.currentUser!.uid,
                        },
                        id: _auth.currentUser!.uid,
                      );
                      Navigator.pushNamed(context, ProfileScreen.id);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
