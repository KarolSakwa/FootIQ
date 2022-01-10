import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/models/question.dart';

class ScoreScreen extends StatelessWidget {
  static const String id = 'score_screen';
  List<Question> userAnsweredQuestionList = [];

  ScoreScreen({Key? key, userAnsweredQuestionList}) : super(key: key) {
    this.userAnsweredQuestionList = userAnsweredQuestionList;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'The quiz is over!',
                  style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 40),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Statistics:",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                'Correct answers: ' +
                    (getUserAnsweredCorrectlyQuestionList().length).toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Question> getUserAnsweredCorrectlyQuestionList() {
    List<Question> userAnsweredCorrectlyQuestionList = [];
    for (var answeredQuestion in userAnsweredQuestionList) {
      if (answeredQuestion.getUserAnswer() ==
          answeredQuestion.getCorrectAnswer())
        userAnsweredCorrectlyQuestionList.add(answeredQuestion);
    }
    return userAnsweredCorrectlyQuestionList;
  }
}
