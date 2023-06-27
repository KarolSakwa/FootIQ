import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/controllers/data_cache_controller.dart';
import 'package:footix/models/question.dart';
import 'package:footix/controllers/question_controller.dart';
import 'package:footix/views/components/question_card/question_card_image.dart';
import 'package:footix/views/components/question_card/question_card_text.dart';
import 'package:footix/views/score_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/models/firebase_service.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

QuestionController questionController = QuestionController();

int maxQuestionNum = 4;
List<Question> answeredQuestionList = [];
const maxSeconds = 15;
final firebaseService = FirebaseService();
List<Icon> scoreKeeper = [];
CountDownController countDownController = CountDownController();
bool isOnCompleteCounterInvoked = false;
final _auth = FirebaseAuth.instance;
final dataCacheController = DataCacheController();

class QuestionCard extends StatefulWidget {
  String challengeID;

  //Question? currentQuestion;
  QuestionCard(String this.challengeID, {Key? key}) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late Question? currentQuestion;
  late List<Question> questionSet;
  bool isLoading = true;
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
    loadQuestion();
    questionController.questionNum = 0;
    scoreKeeper = [];
    super.initState();
  }

  void loadQuestion() async {
    questionSet = await questionController.getQuestionSet();
    currentQuestion = questionSet.first;
    setState(() {
      isLoading = false;
    });
  }

  void updateState(answerText, currentQuestion) {
    answeredQuestionList.add(currentQuestion);
    currentQuestion.setUserAnswer(answerText);
    Future.delayed(const Duration(milliseconds: 0), () {
      // 3000?
      if (answerText == currentQuestion.getCorrectAnswer()) {
        correctAnswerActions();
      } else {
        inCorrectAnswerActions();
      }
    });
    dataCacheController.cacheQuestionData(currentQuestion);
    questionController.questionNum++;
  }

  void timesUpActions() {
    isOnCompleteCounterInvoked = false;
    firebaseService.appendMapValue('challenges', widget.challengeID,
        'questions', currentQuestion!.getID().toString(), false);
    scoreKeeper.add(Icon(
      Icons.close,
      color: Colors.red,
    ));
    questionController.questionNum++;
    Dialogs.materialDialog(
      onClose: closeAlert,
      // for some reason barrierDismissible option not working here, so I have to work it around the other way
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
          color: Colors.red,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  void correctAnswerActions() {
    firebaseService.appendMapValue('challenges', widget.challengeID,
        'questions', currentQuestion!.getID().toString(), true);
    if (_auth.currentUser != null) {
      firebaseService.appendToCorrectArray(
          _auth.currentUser!.uid, currentQuestion!.id.toString());
    }
    isOnCompleteCounterInvoked = false;
    countDownController.pause();
    scoreKeeper.add(Icon(
      Icons.check,
      color: Colors.green,
    ));
    Dialogs.materialDialog(
      onClose: closeAlert,
      // for some reason barrierDismissible option not working here, so I have to work it around the other way
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
          color: Colors.green,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  void inCorrectAnswerActions() {
    firebaseService.appendMapValue('challenges', widget.challengeID,
        'questions', currentQuestion!.getID().toString(), false);
    if (_auth.currentUser != null) {
      firebaseService.appendToIncorrectArray(
          _auth.currentUser!.uid, currentQuestion!.id.toString());
    }
    isOnCompleteCounterInvoked = false;
    countDownController.pause();
    scoreKeeper.add(Icon(
      Icons.close,
      color: Colors.red,
    ));
    Dialogs.materialDialog(
      onClose: closeAlert,
      // for some reason barrierDismissible option not working here, so I have to work it around the other way
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
          color: Colors.red,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              color: kMainLightColor,
              strokeWidth: 5,
            ),
          ))
        : WillPopScope(
            onWillPop: () async => false,
            child: SizedBox(
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
                        QuestionCardImage(question: currentQuestion!),
                        QuestionCardText(question: currentQuestion!)
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
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: TextButton(
                                  onPressed: () {
                                    updateState(currentQuestion!.getAnswerA(),
                                        currentQuestion!);
                                  },
                                  style: currentQuestion!.getUserAnswer() ==
                                          currentQuestion!.getAnswerA()
                                      ? selectedButtonStyle
                                      : initialButtonStyle,
                                  child: Text(
                                    currentQuestion!.getAnswerA(),
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: getFontSize(
                                          currentQuestion!.getAnswerA()),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: TextButton(
                                  onPressed: () {
                                    updateState(currentQuestion!.getAnswerB(),
                                        currentQuestion!);
                                  },
                                  style: currentQuestion!.getUserAnswer() ==
                                          currentQuestion!.getAnswerB()
                                      ? selectedButtonStyle
                                      : initialButtonStyle,
                                  child: Text(
                                    currentQuestion!.getAnswerB(),
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: getFontSize(
                                          currentQuestion!.getAnswerB()),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: TextButton(
                                  onPressed: () {
                                    updateState(currentQuestion!.getAnswerC(),
                                        currentQuestion!);
                                  },
                                  style: currentQuestion!.getUserAnswer() ==
                                          currentQuestion!.getAnswerC()
                                      ? selectedButtonStyle
                                      : initialButtonStyle,
                                  child: Text(
                                    currentQuestion!.getAnswerC(),
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: getFontSize(
                                          currentQuestion!.getAnswerC()),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: TextButton(
                                  onPressed: () {
                                    updateState(currentQuestion!.getAnswerD(),
                                        currentQuestion!);
                                  },
                                  style: currentQuestion!.getUserAnswer() ==
                                          currentQuestion!.getAnswerD()
                                      ? selectedButtonStyle
                                      : initialButtonStyle,
                                  child: Text(
                                    currentQuestion!.getAnswerD(),
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: getFontSize(
                                          currentQuestion!.getAnswerD()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ]),
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
      } else {
        currentQuestion = questionSet[questionController.questionNum];
      }
    });
    if (questionController.questionNum > maxQuestionNum) {
      countDownController.pause();
    } else {
      countDownController.restart();
    }
  }
}
