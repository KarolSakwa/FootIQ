import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/components/question_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuickChallengeScreen extends StatefulWidget {
  static const String id = 'quick_challenge_screen';
  final _auth = FirebaseAuth.instance;
  String loggedInUsername = 'Quick challenge';

  @override
  _QuickChallengeScreenState createState() => _QuickChallengeScreenState();
}

class _QuickChallengeScreenState extends State<QuickChallengeScreen> {
  void initState() {
    if (widget._auth.currentUser != null) {
      widget.loggedInUsername = widget._auth.currentUser!.displayName!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // HEADER SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kAppName,
                  style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 25.0),
                ),
                Text(
                  widget.loggedInUsername,
                  style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 18.0),
                ),
              ],
            ),
            // MAIN BODY
            QuestionCard()
          ],
        ),
      ),
    ));
  }
}
