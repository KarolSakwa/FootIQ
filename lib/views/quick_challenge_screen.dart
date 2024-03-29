import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/components/question_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class QuickChallengeScreen extends StatefulWidget {
  static const String id = 'quick_challenge_screen';
  final _auth = FirebaseAuth.instance;
  String loggedInUsername = 'Quick challenge';

  QuickChallengeScreen({Key? key}) : super(key: key);

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
    return FutureBuilder(
        future: addNewChallenge(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                        style: kWelcomeScreenTitleTextStyle.copyWith(
                            fontSize: 25.0),
                      ),
                      Text(
                        widget.loggedInUsername,
                        style: kWelcomeScreenTitleTextStyle.copyWith(
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                  // MAIN BODY
                  QuestionCard(snapshot.data)
                ],
              ),
            ),
          ));
        });
  }

  dynamic addNewChallenge() async {
    var uuid = const Uuid();
    String ID = uuid.v1();
    firebaseService.addData(
        'challenges',
        {
          'date': FieldValue.serverTimestamp(),
          'questions': {},
          'user': widget._auth.currentUser?.uid
        },
        id: ID);
    return ID;
  }
}
