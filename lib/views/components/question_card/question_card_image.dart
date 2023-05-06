import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footix/models/question.dart';

import '../../../contants.dart';
import '../../../models/competition.dart';

class QuestionCardImage extends StatelessWidget {
  final Question question;

  const QuestionCardImage({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int questionSeason = question.year;
    final Competition questionCompetition = question.competition;

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
                          '${questionSeason.toString()} - ${(questionSeason + 1).toString()}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: kMainLightColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Image.network(
                        questionCompetition.logoPath,
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
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
}
