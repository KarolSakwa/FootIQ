class Question {
  String _imgSrc = '',
      _questionText = '',
      _answerA = '',
      _answerB = '',
      _answerC = '',
      _answerD = '',
      _correctAnswer = '';

  Question(
      {String imgSrc = '',
      required String questionText,
      required String answerA,
      required String answerB,
      required String answerC,
      required String answerD,
      required String correctAnswer}) {
    this._imgSrc = imgSrc;
    this._questionText = questionText;
    this._answerA = answerA;
    this._answerB = answerB;
    this._answerC = answerC;
    this._answerD = answerD;
    this._correctAnswer = correctAnswer;
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
}
