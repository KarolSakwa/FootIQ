import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/models/question.dart';
import 'package:footix/controllers/question_controller.dart';
import 'package:footix/models/question_base.dart';
import 'package:footix/views/score_screen.dart';

QuestionController questionController = QuestionController();
Question currentQuestion = questionController.getNextQuestion();

int maxQuestionNum = QuestionBase().questionList.length;
List<Question> answeredQuestionList = [];

class QuestionCard extends StatefulWidget {
  const QuestionCard({Key? key}) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  ButtonStyle initialButtonStyle = ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(kMainLightColor),
    backgroundColor: MaterialStateProperty.all<Color>(kMainMediumColor),
  );

  ButtonStyle selectedButtonStyle = ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(kMainLightColor),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
  );

  void updateState(answerText) {
    setState(() {
      currentQuestion.setUserAnswer(answerText);
      Future.delayed(Duration(milliseconds: 0), () {
        // 3000?
        if (answerText == currentQuestion.getCorrectAnswer())
          correctAnswerActions();
        else {
          inCorrectAnswerActions();
        }
      });
    });
    answeredQuestionList.add(currentQuestion);
  }

  void correctAnswerActions() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: const Text(
            'Correct!',
            style: TextStyle(color: Colors.green),
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  if (questionController.questionNum <
                      questionController.questionList.length)
                    currentQuestion = questionController.getNextQuestion();
                  else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScoreScreen(
                              userAnsweredQuestionList: answeredQuestionList),
                        ));
                    //Navigator.pushNamed(context, ScoreScreen.id);
                  }
                });
              },
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  void inCorrectAnswerActions() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: const Text(
            'Incorrect! : <',
            style: TextStyle(color: Colors.red),
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  if (questionController.questionNum <
                      questionController.questionList.length) {
                    currentQuestion = questionController.getNextQuestion();
                  } else {
                    Navigator.pushNamed(context, ScoreScreen.id,
                        arguments: answeredQuestionList);
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

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
                                Image.asset(currentQuestion.getImgSrc(),
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
                              child: Text(currentQuestion.getQuestionText(),
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
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextButton(
                        onPressed: () {
                          updateState(currentQuestion.getAnswerA());
                        },
                        style: currentQuestion.getUserAnswer() ==
                                currentQuestion.getAnswerA()
                            ? selectedButtonStyle
                            : initialButtonStyle,
                        child: Text(
                          currentQuestion.getAnswerA(),
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextButton(
                        onPressed: () {
                          updateState(currentQuestion.getAnswerB());
                        },
                        style: currentQuestion.getUserAnswer() ==
                                currentQuestion.getAnswerB()
                            ? selectedButtonStyle
                            : initialButtonStyle,
                        child: Text(
                          currentQuestion.getAnswerB(),
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextButton(
                        onPressed: () {
                          updateState(currentQuestion.getAnswerC());
                        },
                        style: currentQuestion.getUserAnswer() ==
                                currentQuestion.getAnswerC()
                            ? selectedButtonStyle
                            : initialButtonStyle,
                        child: Text(
                          currentQuestion.getAnswerC(),
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextButton(
                        onPressed: () {
                          updateState(currentQuestion.getAnswerD());
                        },
                        style: currentQuestion.getUserAnswer() ==
                                currentQuestion.getAnswerD()
                            ? selectedButtonStyle
                            : initialButtonStyle,
                        child: Text(
                          currentQuestion.getAnswerD(),
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
