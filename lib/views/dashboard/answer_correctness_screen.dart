import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/repository/answered_questions_repository.dart';
import 'package:footix/views/dashboard/components/user_answer_correctneess_pie_chart.dart';
import 'package:footix/contants.dart';

import '../../models/firebase_service.dart';

class AnswerCorrectnessScreen extends StatefulWidget {
  static const String id = 'answer_correctness_screen';
  final firebaseService = FirebaseService();
  final answeredQuestionsRepository = AnsweredQuestionsRepository();
  final _auth = FirebaseAuth.instance;
  AnswerCorrectnessScreen({Key? key}) : super(key: key);

  @override
  State<AnswerCorrectnessScreen> createState() =>
      _AnswerCorrectnessScreenState();
}

class _AnswerCorrectnessScreenState extends State<AnswerCorrectnessScreen> {
  Widget buildNoDataWidget() {
    return Center(
      child: Text(
        'No data available yet.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: kMainDarkColor,
        ),
        body: FutureBuilder<List>(
          future: Future.wait([
            widget.answeredQuestionsRepository
                .getUserAnsweredQuestions(widget._auth.currentUser!.uid),
            getCompetitionAnswerCorrectnessCharts()
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            }
            final correct = snapshot.data[0]['correct'] == null
                ? 0
                : snapshot.data[0]['correct'].length;
            final incorrect = snapshot.data[0]['incorrect'] == null
                ? 0
                : snapshot.data[0]['incorrect'].length;
            return snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data[0].length > 0
                ? Scaffold(
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kMainDefaultPadding),
                          child: Column(
                            children: [
                              Text(
                                'Answer correctness'.toUpperCase(),
                                style: kWelcomeScreenTitleTextStyle.copyWith(
                                    fontSize: 25),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: kMainDefaultPadding),
                                child: Text(
                                  'Total'.toUpperCase(),
                                  style: kWelcomeScreenTitleTextStyle.copyWith(
                                      fontSize: 18),
                                ),
                              ),
                              UserAnswerCorrectnessPieChart(
                                  correctAnswers: correct,
                                  incorrectAnswers: incorrect),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: kMainDefaultPadding),
                                child: Text(
                                  'By competition'.toUpperCase(),
                                  style: kWelcomeScreenTitleTextStyle.copyWith(
                                      fontSize: 18),
                                ),
                              ),
                              snapshot.data[1],
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : buildNoDataWidget();
          },
        ),
      ),
    );
  }

  Future<Widget> getCompetitionAnswerCorrectnessCharts() async {
    var answeredQuestions = await widget.answeredQuestionsRepository
        .getUserAnsweredQuestions(widget._auth.currentUser!.uid);
    var answeredQuestionsPerCompetition = await widget
        .answeredQuestionsRepository
        .divideIntoCompetitions(answeredQuestions);
    List<Widget> widgetList = [];
    for (var i = 0; i < answeredQuestionsPerCompetition.length; i++) {
      var compData = answeredQuestionsPerCompetition[
          answeredQuestionsPerCompetition.keys.toList()[i]];
      widgetList.add(Column(
        children: [
          Text(compData['name'],
              style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 16)),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kMainDefaultPadding),
            child: UserAnswerCorrectnessPieChart(
                correctAnswers: compData['correct'].length,
                incorrectAnswers: compData['incorrect'].length),
          ),
        ],
      ));
    }

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child:
            ListView(scrollDirection: Axis.horizontal, children: widgetList));
  }
}
