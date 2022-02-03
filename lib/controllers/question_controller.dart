import 'package:flutter/material.dart';
import 'package:footix/models/question.dart';
import 'package:footix/models/question_base.dart';

import '../contants.dart';

class QuestionController {
  int questionNum = 0; // probably just a question counter
  int questionNumber = 0; // indicates which question should be displayed
  int questionListLength = 50;

  List getList() {
    return List<int>.generate(questionListLength, (i) => i + 1);
  }

  List indexList = [];

  Future<Question> getNextQuestion2() async {
    if (indexList.isEmpty) indexList = getList();
    indexList.remove(questionNumber);
    List<Map> question;
    Question currentQuestion = Question(
        questionText: 'questionText',
        answerA: 'answerA',
        answerB: 'answerB',
        answerC: 'answerC',
        answerD: 'answerD',
        correctAnswer: 'correctAnswer',
        questionCode: 'questionCode');
    if (questionNum < questionListLength) {
      question = await QuestionBase().getQuestionList();
      questionListLength = question.length;
      currentQuestion = Question(
          questionText: question[questionNumber]['questionText'],
          answerA: question[questionNumber]['answerA'],
          answerB: question[questionNumber]['answerB'],
          answerC: question[questionNumber]['answerC'],
          answerD: question[questionNumber]['answerD'],
          correctAnswer: question[questionNumber]['correctAnswer'],
          imgSrc: question[questionNumber]['imgSrc'],
          questionCode: question[questionNumber]['questionCode']);
      return currentQuestion;
    }
    return currentQuestion;
  }
}
