import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/views/welcome_screen.dart';
import 'dashboard/profile_screen.dart';

class MainScreen extends StatelessWidget {
  static const String id = 'main_screen';
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  Future<User> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
    return loggedInUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            return ProfileScreen();
          }

          /// other way there is no user logged.
          return WelcomeScreen();
        });
  }
}
