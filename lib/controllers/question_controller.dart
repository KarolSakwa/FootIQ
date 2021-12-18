import 'package:flutter/material.dart';
import 'package:footix/models/question.dart';
import 'package:footix/models/question_base.dart';
import 'dart:math';

import '../contants.dart';

class QuestionController {
  int questionNum = 0;
  int questionListLength = 100;

  Future<Question> getNextQuestion2() async {
    final _random = new Random();
    int questionNumber = _random.nextInt(3);
    List<Map> question;
    Question currentQuestion = Question(
        questionText: 'questionText',
        answerA: 'answerA',
        answerB: 'answerB',
        answerC: 'answerC',
        answerD: 'answerD',
        correctAnswer: 'correctAnswer');
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
          imgSrc: question[questionNumber]['imgSrc']);
      questionNum++;
      return currentQuestion;
    }
    return currentQuestion;
  }
}
