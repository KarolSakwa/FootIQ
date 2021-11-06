import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'answer_button.dart';

class QuestionCard extends StatelessWidget {
  String questionText,
      answerA,
      answerB,
      answerC,
      answerD,
      correctAnswer,
      imageSrc = 'assets/question_images/cash.jpg';

  // constructor
  QuestionCard(
      {Key? key,
      required this.questionText,
      required this.answerA,
      required this.answerB,
      required this.answerC,
      required this.answerD,
      required this.correctAnswer,
      this.imageSrc = 'assets/question_images/cash.jpg'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
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
                                Image.asset(imageSrc,
                                    height: MediaQuery.of(context).size.height *
                                        0.25), // gives me 100% of container's height
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            color: kMainLightColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:
                                  Text(questionText, style: kQuestionTextStyle),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  AnswerButton(answerText: 'answerA'),
                  SizedBox(
                    width: 10,
                  ),
                  AnswerButton(answerText: 'answerB'),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  AnswerButton(answerText: 'answerC'),
                  SizedBox(
                    width: 10,
                  ),
                  AnswerButton(answerText: 'answerD'),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
