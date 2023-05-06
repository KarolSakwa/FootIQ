import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/models/database.dart';
import 'package:footix/views/dashboard/components/user_answer_correctneess_pie_chart.dart';

class AnswerCorrectness extends StatefulWidget {
  AnswerCorrectness({Key? key}) : super(key: key);
  final db = DB();
  final _auth = FirebaseAuth.instance;

  @override
  _AnswerCorrectnessState createState() => _AnswerCorrectnessState();
}

class _AnswerCorrectnessState extends State<AnswerCorrectness> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.db.getTotalAnswerCorrectness(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var correctAnswers = snapshot.data['correct'].toInt();
            var incorrectAnswers = snapshot.data['incorrect'].toInt();
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
