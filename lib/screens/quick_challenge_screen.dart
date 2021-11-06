import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/components/question_card.dart';

class QuickChallengeScreen extends StatefulWidget {
  static const String id = 'quick_challenge_screen';

  @override
  _QuickChallengeScreenState createState() => _QuickChallengeScreenState();
}

class _QuickChallengeScreenState extends State<QuickChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  kAppName,
                  style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 25.0),
                ),
              ],
            ),
            QuestionCard(
              questionText:
                  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
              answerA: "dasads",
              answerB: "dasda",
              answerC: "dadsa",
              answerD: "dsadas",
              correctAnswer: "Bla",
            )
          ],
        ),
      ),
    ));
  }
}
