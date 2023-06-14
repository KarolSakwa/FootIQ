import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/views/dashboard/profile_screen.dart';
import 'forgot_password_screen.dart';

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

  bool isEmailValid = true;
  bool isPasswordValid = true;

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
                  child: kWelcomeScreenTitleText,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: kMainLightColor),
                  hintText: 'Enter valid email, e.g. abc@mail.com',
                  errorText: isEmailValid ? null : 'Enter a valid email',
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                    isEmailValid = true;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: kMainLightColor),
                  hintText: 'Enter secure password',
                  errorText: isPasswordValid ? null : 'Password is too short',
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                    isPasswordValid = true;
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, ForgotPasswordScreen.id),
              child: Text('Forgot Password'),
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
                if (email.isEmpty || !isEmailValid) {
                  setState(() {
                    isEmailValid = false;
                  });
                } else if (password.length < 6) {
                  setState(() {
                    isPasswordValid = false;
                  });
                } else {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (!mounted) return;
                    Navigator.pushNamed(context, ProfileScreen.id);
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account'),
          ],
        ),
      ),
    );
  }
}