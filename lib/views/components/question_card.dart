import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'answer_button.dart';

class QuestionCard extends StatelessWidget {
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
              // IMAGE SECTION

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
                                Image.asset('imageSrc',
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

              // QUESTION TEXT

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
                              child: Text('questionText',
                                  style: kQuestionTextStyle),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),

          // ANSWER BUTTONS

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
}
