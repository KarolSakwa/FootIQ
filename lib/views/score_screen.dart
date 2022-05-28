import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/models/database.dart';
import 'package:footix/models/question.dart';
import 'package:footix/views/components/question_card.dart';

import 'dashboard/components/user_answer_correctneess_pie_chart.dart';

class ScoreScreen extends StatefulWidget {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  final db = DB();
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
    if (widget._auth.currentUser != null) {
      loggedInUser = widget._auth.currentUser!;
    }

    super.initState();
  }

  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.getFieldData('challenges', widget.challengeID, 'questions'),
        builder: (BuildContext context, AsyncSnapshot result) {
          int correctAnswersNum = getCorrectAnswersNum(result.data);
          return WillPopScope(
            onWillPop: () async => false,
            child: SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'The quiz is over!',
                        style:
                            kWelcomeScreenTitleTextStyle.copyWith(fontSize: 40),
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
                            incorrectAnswers:
                                result.data.length - correctAnswersNum))
                  ],
                ),
              ),
            ),
          );
        });
  }

  String getQuestionCompetition(Question question) {
    return question
        .getQuestionCode()
        .substring(0, question.getQuestionCode().indexOf('_'));
  }

  getCorrectAnswersNum(Map questionsList) {
    int correctNum = 0;
    for (var i = 0; i < questionsList.keys.toList().length; i++) {
      if (questionsList[questionsList.keys.toList()[i]] == true) {
        correctNum++;
      }
    }
    return correctNum;
  }
}
