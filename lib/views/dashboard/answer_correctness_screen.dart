import 'package:flutter/material.dart';
import 'package:footix/views/dashboard/components/user_answer_correctneess_pie_chart.dart';
import 'package:footix/contants.dart';

import '../../models/database.dart';

class AnswerCorrectnessScreen extends StatefulWidget {
  static const String id = 'answer_correctness_screen';
  final db = DB();
  AnswerCorrectnessScreen({Key? key}) : super(key: key);

  @override
  State<AnswerCorrectnessScreen> createState() =>
      _AnswerCorrectnessScreenState();
}

class _AnswerCorrectnessScreenState extends State<AnswerCorrectnessScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, int>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, int>?;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: kMainDarkColor,
        ),
        body: FutureBuilder<List>(
          future: Future.wait(
              [competitionPieCharts2(), widget.db.getTotalAnswerCorrectness()]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Scaffold(
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
                              correctAnswers: snapshot.data[1]['correct'],
                              incorrectAnswers: snapshot.data[1]['incorrect']),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: kMainDefaultPadding),
                            child: Text(
                              'By competition'.toUpperCase(),
                              style: kWelcomeScreenTitleTextStyle.copyWith(
                                  fontSize: 18),
                            ),
                          ),
                          snapshot.data[0]
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              print('Cannot load data');
              return Scaffold(
                  body: Center(
                    child: Text(kTooLittleData,
                        style:
                            kWelcomeScreenTitleTextStyle.copyWith(fontSize: 26),
                        textAlign: TextAlign.center),
                  ),
                  backgroundColor: kMainDarkColor,
                  appBar: AppBar(
                    title: Text("Answer correctness"),
                    backgroundColor: Color(0xFF0B1724FF),
                  ));
            }
          },
        ),
      ),
    );
  }

  Future<Widget> competitionPieCharts2() async {
    var allCompsMapFull = await widget.db.getCompAnswerCorrectness();

    List<Widget> widgetList = [];
    for (var i = 0; i < allCompsMapFull.length; i++) {
      var currentKey = allCompsMapFull.keys.toList()[i];
      var currentValue = allCompsMapFull[allCompsMapFull.keys.toList()[i]];

      var compData = await widget.db
          .getCollectionDataField('competition', 'tm_code', currentKey);

      widgetList.add(Column(
        children: [
          Text(compData['name'],
              style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 16)),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kMainDefaultPadding),
            child: UserAnswerCorrectnessPieChart(
                correctAnswers: currentValue['correct'],
                incorrectAnswers: currentValue['incorrect']),
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
