import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footix/models/question.dart';

import '../../../contants.dart';

class QuestionCardImage extends StatefulWidget {
  Question question;

  QuestionCardImage({Key? key, required this.question}) : super(key: key);

  @override
  _QuestionCardImageState createState() => _QuestionCardImageState();
}

class _QuestionCardImageState extends State<QuestionCardImage> {
  @override
  Widget build(BuildContext context) {
    String questionSeason = getQuestionSeason(widget.question);
    String questionCompetition = getQuestionCompetition(widget.question);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.92,
          child: Card(
            color: kMainLightColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(color: kMainDarkColor),
                        child: Text(
                          questionSeason,
                          style: TextStyle(
                              fontSize: 18,
                              color: kMainLightColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Image.asset(
                          'assets/competition_images/$questionCompetition.png',
                          height: MediaQuery.of(context).size.height * 0.15),
                      // gives me 100% of container's height
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  String getQuestionSeason(Question question) {
    return question
            .getQuestionCode()
            .substring(question.getQuestionCode().indexOf('_') + 1) +
        '-' +
        (int.parse(question
                    .getQuestionCode()
                    .substring(question.getQuestionCode().indexOf('_') + 1)) +
                1)
            .toString();
  }

  String getQuestionCompetition(Question question) {
    return question
        .getQuestionCode()
        .substring(0, question.getQuestionCode().indexOf('_'));
  }
}
