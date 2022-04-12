import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
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
  int getPercents(int number) {
    if (number == 0) return 0;
    return ((number / userAnsweredQuestionList.length) * 100).toInt();
  }

  static const String id = 'score_screen';
  List<Question> userAnsweredQuestionList = [];

  ScoreScreen({Key? key, userAnsweredQuestionList}) : super(key: key) {
    this.userAnsweredQuestionList = userAnsweredQuestionList;
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
    for (var i = 0; i < widget.userAnsweredQuestionList.length; i++) {
      if (getUserAnsweredCorrectlyQuestionList()
          .contains(widget.userAnsweredQuestionList[i])) {
        widget.db.incrementUserCompExp(loggedInUser.uid,
            getQuestionCompetition(widget.userAnsweredQuestionList[i]), 1);
      }
    }
    super.initState();
  }

  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'The quiz is over!',
                  style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 40),
                ),
              ),
              SizedBox(
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
                      correctAnswers:
                          getUserAnsweredCorrectlyQuestionList().length,
                      incorrectAnswers: widget.userAnsweredQuestionList.length -
                          getUserAnsweredCorrectlyQuestionList().length))
            ],
          ),
        ),
      ),
    );
  }

  List<Question> getUserAnsweredCorrectlyQuestionList() {
    List<Question> userAnsweredCorrectlyQuestionList = [];
    for (var answeredQuestion in widget.userAnsweredQuestionList) {
      if (answeredQuestion.getUserAnswer() ==
          answeredQuestion.getCorrectAnswer())
        userAnsweredCorrectlyQuestionList.add(answeredQuestion);
    }
    return userAnsweredCorrectlyQuestionList;
  }

  String getQuestionCompetition(Question question) {
    return question
        .getQuestionCode()
        .substring(0, question.getQuestionCode().indexOf('_'));
  }
}
