import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/models/database.dart';
import 'package:footix/models/question.dart';
import 'package:footix/views/components/question_card.dart';

class ScoreScreen extends StatefulWidget {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  final db = DB();
  int getPercents(int number) {
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
      loggedInUser = widget._auth.currentUser;
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
                  child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                              radius: 80,
                              title: widget
                                      .getPercents(
                                          getUserAnsweredCorrectlyQuestionList()
                                              .length)
                                      .toString() +
                                  '%',
                              titleStyle: TextStyle(
                                  fontSize: 30,
                                  color: kMainLightColor,
                                  fontWeight: FontWeight.bold),
                              color: Colors.green,
                              value: getUserAnsweredCorrectlyQuestionList()
                                  .length
                                  .toDouble()),
                          PieChartSectionData(
                              radius: 80,
                              title: widget
                                      .getPercents(widget
                                              .userAnsweredQuestionList.length -
                                          getUserAnsweredCorrectlyQuestionList()
                                              .length)
                                      .toString() +
                                  '%',
                              titleStyle: TextStyle(
                                  fontSize: 30,
                                  color: kMainLightColor,
                                  fontWeight: FontWeight.bold),
                              color: Colors.redAccent,
                              value: widget.userAnsweredQuestionList.length -
                                  getUserAnsweredCorrectlyQuestionList()
                                      .length
                                      .toDouble())
                        ]),
                    swapAnimationDuration:
                        Duration(milliseconds: 150), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ))
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
