import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/contants.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/database.dart';

class UserAnswerCorrectnessPieChart extends StatelessWidget {
  UserAnswerCorrectnessPieChart({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  final db = DB();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAnswerCorrectnessMap(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          double correct = snapshot.data['answeredCorrectlyTotal'];
          double totalQuestions = snapshot.data['askedTimesTotal'];
          double incorrect = totalQuestions - correct;
          int answerCorrectnessPercentage =
              ((correct / totalQuestions) * 100).round();
          return Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: kMainDefaultPadding),
            child: PieChart(
              centerText: answerCorrectnessPercentage.toString() + '%',
              centerTextStyle:
                  kWelcomeScreenTitleTextStyle.copyWith(fontSize: 25),
              dataMap: {
                //'d': 2
                'correct': correct,
                'incorrect': incorrect
              },
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              colorList: const [
                kMainLightColor,
                Colors.transparent,
              ],
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: false,
                //legendShape: _BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: const ChartValuesOptions(
                chartValueStyle: TextStyle(
                    color: kMainLightColor, fontWeight: FontWeight.w700),
                showChartValueBackground: false,
                showChartValues: false,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
                decimalPlaces: 1,
              ),
              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            ),
          ));
        });
  }

  getAnswerCorrectnessMap() async {
    var answerCorrectnessRaw = await db.getFieldData(
        'users', _auth.currentUser?.uid, 'answeredQuestions');
    List keys = answerCorrectnessRaw.keys.toList();
    Map<String, double> answerCorrectness = {
      'askedTimesTotal': 0,
      'answeredCorrectlyTotal': 0
    };
    for (var i = 0; i < answerCorrectnessRaw.length; i++) {
      double askedTimes =
          answerCorrectnessRaw[keys[i]]['askedTimes'].toDouble();
      double answeredCorrectly =
          answerCorrectnessRaw[keys[i]]['answeredCorrectly'].toDouble();
      answerCorrectness['askedTimesTotal'] =
          (answerCorrectness['askedTimesTotal']! + askedTimes);
      answerCorrectness['answeredCorrectlyTotal'] =
          (answerCorrectness['answeredCorrectlyTotal']! + answeredCorrectly);
    }
    return answerCorrectness;
  }
}
