import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/contants.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/database.dart';

class UserAnswerCorrectnessPieChart extends StatelessWidget {
  int? correctAnswers;
  int? incorrectAnswers;
  double? chartRadius;
  UserAnswerCorrectnessPieChart(
      {Key? key,
      required this.correctAnswers,
      required this.incorrectAnswers,
      this.chartRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var answerCorrectnessPercentage =
        correctAnswers != 0 || incorrectAnswers != 0
            ? ((correctAnswers! / (correctAnswers! + incorrectAnswers!)) * 100)
                .round()
            : null;
    chartRadius ??= MediaQuery.of(context).size.width / 3.2;
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: kMainDefaultPadding),
      child: answerCorrectnessPercentage == null
          ? Text(
              kNoAnsweredQuestions,
              style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 14),
            )
          : PieChart(
              centerText: answerCorrectnessPercentage.toString() + '%',
              centerTextStyle:
                  kWelcomeScreenTitleTextStyle.copyWith(fontSize: 25),
              dataMap: {
                'correct': correctAnswers!.toDouble(),
                'incorrect': incorrectAnswers!.toDouble()
              },
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: chartRadius,
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
  }
}
