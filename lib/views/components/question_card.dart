import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/models/question.dart';
import 'package:footix/controllers/question_controller.dart';
import 'package:footix/views/score_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/models/database.dart';

QuestionController questionController = QuestionController();

int maxQuestionNum = 3;
List<Question> answeredQuestionList = [];
final _random = Random();
const maxSeconds = 15;
int seconds = maxSeconds;
Timer? timer;
final _auth = FirebaseAuth.instance;
late User loggedInUser;
final db = DB();
List<Icon> scoreKeeper = [];

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
    loggedInUser = _auth.currentUser!;
    questionController.questionNumber =
        _random.nextInt(questionController.questionListLength);
    startTimer();
    super.initState();
  }

  void updateState(answerText, currentQuestion) {
    questionController.questionNum++;
    setState(() {
      Question question = currentQuestion;
      answeredQuestionList.add(currentQuestion);
      currentQuestion.setUserAnswer(answerText);
      Future.delayed(Duration(milliseconds: 0), () {
        // 3000?
        if (answerText == currentQuestion.getCorrectAnswer()) {
          correctAnswerActions();
          updateAnsweredQuestions(currentQuestion.getID(), true);
          db.appendMapValue('challenges', widget.challengeID, 'questions',
              currentQuestion.getID(), true);
        } else {
          inCorrectAnswerActions();
          updateAnsweredQuestions(currentQuestion.getID(), false);
          db.appendMapValue('challenges', widget.challengeID, 'questions',
              currentQuestion.getID(), false);
        }
      });
    });
  }

  void timesUpActions() {
    db.appendMapValue('challenges', widget.challengeID, 'questions',
        widget.currentQuestion!.getID(), false);
    scoreKeeper.add(Icon(
      Icons.close,
      color: Colors.red,
    ));
    questionController.questionNum++;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Center(
            child: const Text(
              'Time\'s up!',
              style: TextStyle(color: Colors.red),
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    seconds = maxSeconds;
                    Navigator.pop(context);
                    if (questionController.questionNum > maxQuestionNum) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScoreScreen(widget.challengeID),
                          ));
                      //Navigator.pushNamed(context, ScoreScreen.id);
                    }
                    questionController.questionNumber =
                        _random.nextInt(questionController.questionListLength);
                  });
                  if (questionController.questionNum > maxQuestionNum)
                    timer!.cancel();
                  else
                    startTimer();
                },
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void correctAnswerActions() {
    scoreKeeper.add(Icon(
      Icons.check,
      color: Colors.green,
    ));
    // znajdujemy zalogowanego użytkownika w bazie, przypisujemy do jego pola exp podpole z nazwą kategorii (rozgrywek), określoną liczbę expa\
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
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
                    if (questionController.questionNum > maxQuestionNum) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScoreScreen(widget.challengeID),
                          ));
                      //Navigator.pushNamed(context, ScoreScreen.id);
                    }
                    questionController.questionNumber =
                        _random.nextInt(questionController.questionListLength);
                  });
                  if (questionController.questionNum > maxQuestionNum)
                    timer!.cancel();
                  else
                    startTimer();
                },
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void inCorrectAnswerActions() {
    scoreKeeper.add(Icon(
      Icons.close,
      color: Colors.red,
    ));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
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
                    Navigator.pop(context);
                    if (questionController.questionNum > maxQuestionNum) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScoreScreen(widget.challengeID),
                          ));
                    }
                    questionController.questionNumber =
                        _random.nextInt(questionController.questionListLength);
                  });
                  if (questionController.questionNum > maxQuestionNum)
                    timer!.cancel();
                  else
                    startTimer();
                },
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
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
            String questionSeason = getQuestionSeason(result.data!);
            String questionCompetition = getQuestionCompetition(result.data!);
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
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: kMainDarkColor),
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15),
                                        // gives me 100% of container's height
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
                                      child: Text(
                                          result.data!.getQuestionText(),
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
                                  updateState(
                                      result.data!.getAnswerA(), result.data!);
                                  timer!.cancel();
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
                                  timer!.cancel();
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
                                  timer!.cancel();
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
                                  timer!.cancel();
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
            return const Center(
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

  Widget buildTimer() => SizedBox(
        width: 70,
        height: 70,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: seconds / maxSeconds,
              strokeWidth: 12,
              valueColor: const AlwaysStoppedAnimation(kMainLightColor),
              backgroundColor: kMainDarkColor,
            ),
            Center(
              child: buildTime(),
            )
          ],
        ),
      );

  Widget buildTime() {
    return Text(
      '$seconds',
      style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 32.0),
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

  updateAnsweredQuestions(questionID, correctAnswer) async {
    // var answeredQuestions =
    //     await db.getFieldData('users', loggedInUser.uid, 'answeredQuestions');
    // int correctAnswers = 0;
    // if (!answeredQuestions.containsKey(questionID)) {
    //   correctAnswers = correctAnswer ? 1 : 0;
    //   db.addMapData('users', loggedInUser.uid, 'answeredQuestions', {
    //     questionID: {'askedTimes': 1, 'answeredCorrectly': correctAnswers}
    //   });
    // } else {
    //   correctAnswers = correctAnswer ? 1 : 0;
    //   db.incrementMapValue('users', loggedInUser.uid, 'answeredQuestions',
    //       questionID, 1, 'askedTimes');
    //   db.incrementMapValue('users', loggedInUser.uid, 'answeredQuestions',
    //       questionID, correctAnswers.toDouble(), 'answeredCorrectly');
    // }
  }

  void startTimer() {
    seconds = maxSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer!.cancel();
        timesUpActions();
      }
    });
  }

  double getFontSize(String txt) {
    return txt.length > 20 ? 12 : 16;
  }
}
