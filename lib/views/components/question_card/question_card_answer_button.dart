import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../contants.dart';
import '../../../models/question.dart';

class QuestionCardAnswerButton extends TextButton {
  final Question question;
  @override
  final ButtonStyle style = kAnswerInitialButtonStyle;

  QuestionCardAnswerButton(
      {Key? key,
      required VoidCallback? onPressed,
      required Widget child,
      required this.question})
      : super(
          key: key,
          onPressed: onPressed,
          child: child,
        );
}
