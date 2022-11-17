import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/models/question.dart';
import 'package:footix/controllers/question_controller.dart';
import 'package:footix/views/components/question_card/question_card_image.dart';
import 'package:footix/views/components/question_card/question_card_text.dart';
import 'package:footix/views/score_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/models/database.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

QuestionController questionController = QuestionController();

int maxQuestionNum = 5;
List<Question> answeredQuestionList = [];
const maxSeconds = 3;
late User loggedInUser;
final db = DB();
List<Icon> scoreKeeper = [];
CountDownController countDownController = CountDownController();
bool isOnCompleteCounterInvoked = false;

class QuestionCard extends StatefulWidget {
  String challengeID;
  Question? currentQuestion;
  QuestionCard(String this.challengeID, {Key? key}) : super(key: key);
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

  @override
  void initState() {
    questionController.questionNum = 0;
    scoreKeeper = [];
    super.initState();
  }

  void updateState(answerText, currentQuestion) {
    answeredQuestionList.add(currentQuestion);
    currentQuestion.setUserAnswer(answerText);
    Future.delayed(const Duration(milliseconds: 0), () {
      // 3000?
      if (answerText == currentQuestion.getCorrectAnswer()) {
        correctAnswerActions();
        db.appendMapValue('challenges', widget.challengeID, 'questions',
            currentQuestion.getID(), true);
      } else {
        inCorrectAnswerActions();
        db.appendMapValue('challenges', widget.challengeID, 'questions',
            currentQuestion.getID(), false);
      }
    });
    questionController.questionNum++;
  }

  void timesUpActions() {
    isOnCompleteCounterInvoked = false;
    db.appendMapValue('challenges', widget.challengeID, 'questions',
        widget.currentQuestion!.getID(), false);
    scoreKeeper.add(Icon(
      Icons.close,
      color: Colors.red,
    ));
    questionController.questionNum++;
    Dialogs.materialDialog(
      onClose:
          closeAlert, // for some reason barrierDismissible option not working here, so I have to work it around the other way
      color: Colors.white,
      title: 'Time\'s up!',
      lottieBuilder: Lottie.asset(
        'assets/lotties/incorrect.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: 0.3,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            closeAlert(true);
          },
          text: 'Ok',
          iconData: Icons.done,
          color: kMainRed,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  void correctAnswerActions() {
    isOnCompleteCounterInvoked = false;
    countDownController.pause();
    scoreKeeper.add(Icon(
      Icons.check,
      color: Colors.green,
    ));
    Dialogs.materialDialog(
      onClose:
          closeAlert, // for some reason barrierDismissible option not working here, so I have to work it around the other way
      color: Colors.white,
      title: 'Correct!',
      lottieBuilder: Lottie.asset(
        'assets/lotties/correct.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: 0.3,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            closeAlert(true);
          },
          text: 'Ok',
          iconData: Icons.done,
          color: kMainLightColor,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  void inCorrectAnswerActions() {
    isOnCompleteCounterInvoked = false;
    countDownController.pause();
    scoreKeeper.add(Icon(
      Icons.close,
      color: kMainRed,
    ));
    Dialogs.materialDialog(
      onClose:
          closeAlert, // for some reason barrierDismissible option not working here, so I have to work it around the other way
      color: Colors.white,
      title: 'Incorrect!',
      lottieBuilder: Lottie.asset(
        'assets/lotties/incorrect.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: 0.3,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            closeAlert(true);
          },
          text: 'Ok',
          iconData: Icons.done,
          color: kMainRed,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder<Question>(
        future: questionController.getNextQuestion(),
        builder: (BuildContext context, AsyncSnapshot<Question> result) {
          if (result.hasData &&
              questionController.questionNum <= maxQuestionNum) {
            widget.currentQuestion = result.data!;
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTimer(),
                  Row(
                    children: scoreKeeper,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      QuestionCardImage(question: result.data!),
                      QuestionCardText(question: result.data!)
                    ],
                  ),
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
                                  updateState(
                                      result.data!.getAnswerA(), result.data!);
                                },
                                style: result.data!.getUserAnswer() ==
                                        result.data!.getAnswerA()
                                    ? selectedButtonStyle
                                    : initialButtonStyle,
                                child: Text(
                                  result.data!.getAnswerA(),
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize:
                                        getFontSize(result.data!.getAnswerA()),
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
                                  updateState(
                                      result.data!.getAnswerB(), result.data!);
                                },
                                style: result.data!.getUserAnswer() ==
                                        result.data!.getAnswerB()
                                    ? selectedButtonStyle
                                    : initialButtonStyle,
                                child: Text(
                                  result.data!.getAnswerB(),
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize:
                                        getFontSize(result.data!.getAnswerB()),
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
                                  updateState(
                                      result.data!.getAnswerC(), result.data!);
                                },
                                style: result.data!.getUserAnswer() ==
                                        result.data!.getAnswerC()
                                    ? selectedButtonStyle
                                    : initialButtonStyle,
                                child: Text(
                                  result.data!.getAnswerC(),
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize:
                                        getFontSize(result.data!.getAnswerC()),
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
                                  updateState(
                                      result.data!.getAnswerD(), result.data!);
                                },
                                style: result.data!.getUserAnswer() ==
                                        result.data!.getAnswerD()
                                    ? selectedButtonStyle
                                    : initialButtonStyle,
                                child: Text(
                                  result.data!.getAnswerD(),
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize:
                                        getFontSize(result.data!.getAnswerD()),
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
          } else {
            return Center(
                child: SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                color: kMainLightColor,
                strokeWidth: 5,
              ),
            ));
          }
        },
      ),
    );
  }

  Widget buildTimer() {
    return CircularCountDownTimer(
        width: 70,
        height: 70,
        strokeWidth: 12,
        duration: maxSeconds,
        fillColor: kMainLightColor,
        ringColor: kMainLightColor.withOpacity(0.25),
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: true,
        textFormat: CountdownTextFormat.S,
        textStyle: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 30),
        autoStart: true,
        controller: countDownController,
        onStart: () {
          isOnCompleteCounterInvoked = true;
        },
        onComplete: () {
          if (isOnCompleteCounterInvoked) {
            timesUpActions();
          }
        });
  }

  double getFontSize(String txt) {
    return txt.length > 20 ? 12 : 16;
  }

  dynamic closeAlert(navigatorPop) {
    if (navigatorPop != null) {
      Navigator.pop(context);
    }

    setState(() {
      if (questionController.questionNum > maxQuestionNum) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScoreScreen(widget.challengeID),
            ));
        //Navigator.pushNamed(context, ScoreScreen.id);
      }
    });
    if (questionController.questionNum > maxQuestionNum) {
      countDownController.pause();
    } else {
      countDownController.restart();
    }
  }
}
