import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import '../../quick_challenge_screen.dart';

class Footer extends StatelessWidget {
  final Map? otherUser;
  const Footer({Key? key, this.otherUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    User? loggedInUser = _auth.currentUser;

    return otherUser == null || otherUser!['email'] == loggedInUser?.email
        ? Material(
            color: Colors.greenAccent,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, QuickChallengeScreen.id);
              },
              child: SizedBox(
                height: kToolbarHeight,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'New challenge'.toUpperCase(),
                    style: TextStyle(
                      color: kMainDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Text('');
  }
}
