import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../contants.dart';
import '../../../models/question.dart';

class QuestionCardText extends StatefulWidget {
  Question question;

  QuestionCardText({Key? key, required this.question}) : super(key: key);

  @override
  _QuestionCardTextState createState() => _QuestionCardTextState();
}

class _QuestionCardTextState extends State<QuestionCardText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: kMainLightColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(widget.question.getQuestionText(),
              style: kQuestionTextStyle),
        ),
      ),
    );
  }
}
