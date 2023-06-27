import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/models/firebase_service.dart';
import 'package:footix/models/question.dart';
import 'package:footix/views/components/question_card.dart';
import 'package:footix/views/dashboard/profile_screen.dart';
import 'package:footix/views/main_screen.dart';
import 'package:footix/views/quick_challenge_screen.dart';

import 'dashboard/components/user_answer_correctneess_pie_chart.dart';

class ScoreScreen extends StatefulWidget {
  final _auth = FirebaseAuth.instance;
  final firebaseService = FirebaseService();
  static const String id = 'score_screen';
  String challengeID = '';

  ScoreScreen(String? challengeID, {Key? key}) : super(key: key) {
    this.challengeID = challengeID!;
  }

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  void initState() {
    super.initState();
  }

  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    String goBackDirection =
        widget._auth.currentUser == null ? MainScreen.id : ProfileScreen.id;

    return FutureBuilder(
      future: widget.firebaseService
          .getFieldData('challenges', widget.challengeID, 'questions'),
      builder: (BuildContext context, AsyncSnapshot result) {
        int correctAnswersNum = getCorrectAnswersNum(result.data);
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Back"),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamed(context, goBackDirection);
                },
              ),
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Challenge completed!',
                    style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Answer correctness",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: UserAnswerCorrectnessPieChart(
                    correctAnswers: correctAnswersNum,
                    incorrectAnswers: result.data.length - correctAnswersNum,
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kMainMediumColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 80.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'New challenge',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: kMainLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, QuickChallengeScreen.id);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getCorrectAnswersNum(Map? questionsList) {
    int correctNum = 0;
    if (questionsList != null) {
      for (var i = 0; i < questionsList.keys.toList().length; i++) {
        if (questionsList[questionsList.keys.toList()[i]] == true) {
          correctNum++;
        }
      }
    }
    return correctNum;
  }
}
