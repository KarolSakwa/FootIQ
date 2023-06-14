import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/models/firebase_service.dart';
import 'package:footix/repository/answered_questions_repository.dart';
import 'package:footix/views/dashboard/components/user_answer_correctneess_pie_chart.dart';

class AnswerCorrectness extends StatefulWidget {
  AnswerCorrectness({Key? key}) : super(key: key);
  final firebaseService = FirebaseService();
  final _auth = FirebaseAuth.instance;
  AnsweredQuestionsRepository answeredQuestionsRepository =
      AnsweredQuestionsRepository();

  @override
  _AnswerCorrectnessState createState() => _AnswerCorrectnessState();
}

class _AnswerCorrectnessState extends State<AnswerCorrectness> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.answeredQuestionsRepository
            .getUserAnsweredQuestions(widget._auth.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var correctAnswers = snapshot.data['correct'] == null
                ? 0
                : snapshot.data['correct'].length;
            var incorrectAnswers = snapshot.data['incorrect'] == null
                ? 0
                : snapshot.data['incorrect'].length;
            return UserAnswerCorrectnessPieChart(
                correctAnswers: correctAnswers,
                incorrectAnswers: incorrectAnswers);
          } else {
            return Container(
                child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  kTooLittleData,
                  style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ));
          }
        });
  }
}
