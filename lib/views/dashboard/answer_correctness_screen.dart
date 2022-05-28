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
    widget.db.getUserAnsweredQuestionsByComp();
    Map<String, int>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, int>?;
    return FutureBuilder<List>(
      future: Future.wait([
        widget.db.getUserAnsweredQuestionsByComp(),
        widget.db.getCollectionData('competition', 'name')
      ]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kMainDefaultPadding),
                  child: Column(
                    children: [
                      Text(
                        'Answer correctness'.toUpperCase(),
                        style:
                            kWelcomeScreenTitleTextStyle.copyWith(fontSize: 25),
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
                          correctAnswers: args!['correctAnswers'],
                          incorrectAnswers: args['incorrectAnswers']),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kMainDefaultPadding),
                        child: Text(
                          'By competition'.toUpperCase(),
                          style: kWelcomeScreenTitleTextStyle.copyWith(
                              fontSize: 18),
                        ),
                      ),
                      allPieCharts(snapshot.data[0], snapshot.data[1])
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  allPieCharts(data, competitions) {
    var finalMap = {};
    List<Widget> widgetList = [];
    //print(data);
    for (var i = 0; i < data.length; i++) {
      finalMap[data.keys.toList()[i]] = {};
      var current = data[data.keys.toList()[i]];
      var correct = 0;
      for (var j = 0; j < current.length; j++) {
        if (current[j][current[j].keys.toList()[0]] == true) {
          correct++;
        }
      }
      finalMap[data.keys.toList()[i]]['correct'] = correct;
      finalMap[data.keys.toList()[i]]['incorrect'] = current.length - correct;

      widgetList.add(Column(
        children: [
          Text(data.keys.toList()[i].toString(),
              style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 16)),
          UserAnswerCorrectnessPieChart(
              correctAnswers: finalMap[data.keys.toList()[i]]['correct'],
              incorrectAnswers: finalMap[data.keys.toList()[i]]['incorrect']),
        ],
      ));
    }
    return new Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child: new ListView(
            scrollDirection: Axis.horizontal, children: widgetList));
  }

  competitionPieCharts() {
    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //   child: Column(
    //     children: [
    //       Text('YU',
    //           style: kWelcomeScreenTitleTextStyle.copyWith(
    //               fontSize: 16)),
    //       UserAnswerCorrectnessPieChart(
    //           correctAnswers: args!['correctAnswers'],
    //           incorrectAnswers: args['incorrectAnswers']),
    //     ],
    //   ),
    // ),
  }
}
