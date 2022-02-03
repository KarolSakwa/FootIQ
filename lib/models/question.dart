import 'package:flutter/cupertino.dart';

class Question {
  String _imgSrc = '',
      _questionText = '',
      _answerA = '',
      _answerB = '',
      _answerC = '',
      _answerD = '',
      _correctAnswer = '',
      _userAnswer = '',
      _questionCode = '',
      _questionCategory = '';

  Question(
      {String imgSrc = '',
      String questionCategory = '',
      required String questionText,
      required String answerA,
      required String answerB,
      required String answerC,
      required String answerD,
      required String correctAnswer,
      required String questionCode,
      String userAnswer = ''}) {
    this._imgSrc = imgSrc;
    this._questionText = questionText;
    this._answerA = answerA;
    this._answerB = answerB;
    this._answerC = answerC;
    this._answerD = answerD;
    this._correctAnswer = correctAnswer;
    this._userAnswer = userAnswer;
    this._questionCode = questionCode;
    this._questionCategory = questionCategory;
  }

  String getImgSrc() {
    return _imgSrc;
  }

  String getQuestionText() {
    return _questionText;
  }

  String getAnswerA() {
    return _answerA;
  }

  String getAnswerB() {
    return _answerB;
  }

  String getAnswerC() {
    return _answerC;
  }

  String getAnswerD() {
    return _answerD;
  }

  String getCorrectAnswer() {
    return _correctAnswer;
  }

  String getUserAnswer() {
    return _userAnswer;
  }

  String getQuestionCategory() {
    return _questionCategory;
  }

  String getQuestionCode() {
    return _questionCode;
  }

  setUserAnswer(userAnswer) {
    this._userAnswer = userAnswer;
  }
}
