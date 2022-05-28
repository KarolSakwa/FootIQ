import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/views/dashboard/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainDarkColor,
      appBar: AppBar(
        title: const Text("Login"),
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
            const SizedBox(
              height: 50,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: BorderSide(color: kMainLightColor, width: 1),
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
              child: TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: BorderSide(color: kMainLightColor, width: 1),
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
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            TextButton(
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
                  children: const [
                    Text(
                      'Log In',
                      style: TextStyle(fontSize: 20.0, color: kMainLightColor),
                    ),
                  ],
                ),
              ),
              onPressed: () async {
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {
                    Navigator.pushNamed(context, ProfileScreen.id);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            const SizedBox(
              height: 130,
            ),
            const Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
