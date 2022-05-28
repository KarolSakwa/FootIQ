class Question {
  String _imgSrc = '',
      _ID = '',
      _questionText = '',
      _answerA = '',
      _answerB = '',
      _answerC = '',
      _answerD = '',
      _correctAnswer = '',
      _userAnswer = '',
      _questionCode = '',
      _questionCategory = '';
  double _difficulty = 0;

  Question(
      {String imgSrc = '',
      String questionCategory = '',
      required String ID,
      required String questionText,
      required String answerA,
      required String answerB,
      required String answerC,
      required String answerD,
      required String correctAnswer,
      required String questionCode,
      String userAnswer = '',
      required double difficulty}) {
    _imgSrc = imgSrc;
    _ID = ID;
    _questionText = questionText;
    _answerA = answerA;
    _answerB = answerB;
    _answerC = answerC;
    _answerD = answerD;
    _correctAnswer = correctAnswer;
    _userAnswer = userAnswer;
    _questionCode = questionCode;
    _questionCategory = questionCategory;
    _difficulty = difficulty;
  }

  String getImgSrc() {
    return _imgSrc;
  }

  String getID() {
    return _ID;
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

  double getQuestionDifficulty() {
    return _difficulty;
  }

  setUserAnswer(userAnswer) {
    _userAnswer = userAnswer;
  }
}
