import 'package:flutter/material.dart';
import 'package:footix/contants.dart';

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    Key? key,
    required this.answerText,
  }) : super(key: key);
  final String answerText;

  @override
  _AnswerButtonState createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  String answerText = '';
  void initState() {
    answerText = widget.answerText;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: TextButton(
          onPressed: () {
            setState(() {});
          },
          child: Text(answerText),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(kMainLightColor),
            backgroundColor: MaterialStateProperty.all<Color>(kMainMediumColor),
          ),
        ),
      ),
    );
  }
}
