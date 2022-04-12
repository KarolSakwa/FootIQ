import 'package:flutter/material.dart';
import 'package:footix/views/dashboard/components/user_answer_correctneess_pie_chart.dart';
import 'package:footix/contants.dart';

class AnswerCorrectnessScreen extends StatelessWidget {
  static const String id = 'answer_correctness_screen';
  const AnswerCorrectnessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, int>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, int>?;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Answer correctness'.toUpperCase(),
                style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 25),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kMainDefaultPadding),
                child: Text(
                  'Total'.toUpperCase(),
                  style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 18),
                ),
              ),
              UserAnswerCorrectnessPieChart(
                  correctAnswers: args!['correctAnswers'],
                  incorrectAnswers: args['incorrectAnswers']),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kMainDefaultPadding),
                child: Text(
                  'By competition'.toUpperCase(),
                  style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 200.0,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => Card(
                    child: Center(child: Text('Dummy Card Text')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: retrieving answer correctness by comp and place it in horizontal listview

}
