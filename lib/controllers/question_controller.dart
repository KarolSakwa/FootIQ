import 'package:flutter/material.dart';
import 'package:footix/models/question.dart';
import 'package:footix/models/question_base.dart';

import '../contants.dart';

class QuestionController {
  int questionNum = 0;
  List<Map> questionList = QuestionBase().questionList;

  getNextQuestion() {
    // Question yuahu = getNextQuestion2();
    // print(yuahu.getAnswerA());
    // HERE IS WHERE I AM GOING TO RETRIEVE THE DATA FROM DB
    if (questionNum < questionList.length) {
      Map selectedQuestion = questionList[questionNum];
      Question currentQuestion = Question(
          questionText: selectedQuestion['questionText'],
          answerA: selectedQuestion['answerA'],
          answerB: selectedQuestion['answerB'],
          answerC: selectedQuestion['answerC'],
          answerD: selectedQuestion['answerD'],
          correctAnswer: selectedQuestion['correctAnswer'],
          imgSrc: selectedQuestion['imgSrc']);
      questionNum++;
      return currentQuestion;
    }
  }

  getNextQuestion2() async {
    List<Map> yu;
    Question currentQuestion = Question(
        questionText: 'questionText',
        answerA: 'answerA',
        answerB: 'answerB',
        answerC: 'answerC',
        answerD: 'answerD',
        correctAnswer: 'correctAnswer');
    if (questionNum < questionList.length) {
      yu = await QuestionBase().getQuestionList();
      currentQuestion = Question(
          questionText: yu[0]['questionText'],
          answerA: yu[0]['answerA'],
          answerB: yu[0]['answerB'],
          answerC: yu[0]['answerC'],
          answerD: yu[0]['answerD'],
          correctAnswer: yu[0]['correctAnswer'],
          imgSrc: yu[0]['imgSrc']);
      questionNum++;
      return currentQuestion;
    }
    return currentQuestion;
  }
}
