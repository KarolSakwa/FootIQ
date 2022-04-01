import 'package:firebase_auth/firebase_auth.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/database.dart';

class UserAnswerCorrectnessPieChart extends StatelessWidget {
  UserAnswerCorrectnessPieChart({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  final db = DB();

  @override
  Widget build(BuildContext context) {
    return Center();
    //   PieChart(
    //   dataMap: dataMap,
    //   animationDuration: Duration(milliseconds: 800),
    //   chartLegendSpacing: 32,
    //   chartRadius: MediaQuery.of(context).size.width / 3.2,
    //   colorList: colorList,
    //   initialAngleInDegree: 0,
    //   chartType: ChartType.ring,
    //   ringStrokeWidth: 32,
    //   centerText: "HYBRID",
    //   legendOptions: LegendOptions(
    //     showLegendsInRow: false,
    //     legendPosition: LegendPosition.right,
    //     showLegends: true,
    //     legendShape: _BoxShape.circle,
    //     legendTextStyle: TextStyle(
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   chartValuesOptions: ChartValuesOptions(
    //     showChartValueBackground: true,
    //     showChartValues: true,
    //     showChartValuesInPercentage: false,
    //     showChartValuesOutside: false,
    //     decimalPlaces: 1,
    //   ),
    //   // gradientList: ---To add gradient colors---
    //   // emptyColorGradient: ---Empty Color gradient---
    // );
  }

  getAnswerCorrectnessMap() async {
    //var answerCorrectnessRaw = await db.
  }
}
