import 'competition.dart';

class Question {
  String imgSrc;
  int id;
  String questionText;
  String answerA;
  String answerB;
  String answerC;
  String answerD;
  String correctAnswer;
  String userAnswer;
  double difficulty;
  Competition competition;
  int year;

  Question({
    this.imgSrc = '',
    required this.id,
    required this.questionText,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.correctAnswer,
    this.userAnswer = '',
    required this.difficulty,
    required this.competition,
    required this.year,
  });

  String getImgSrc() {
    return imgSrc;
  }

  int getID() {
    return id;
  }

  String getQuestionText() {
    return questionText;
  }

  String getAnswerA() {
    return answerA;
  }

  String getAnswerB() {
    return answerB;
  }

  String getAnswerC() {
    return answerC;
  }

  String getAnswerD() {
    return answerD;
  }

  String getCorrectAnswer() {
    return correctAnswer;
  }

  String getUserAnswer() {
    return userAnswer;
  }

  double getQuestionDifficulty() {
    return difficulty;
  }

  void setUserAnswer(String userAnswer) {
    this.userAnswer = userAnswer;
  }

  toJson() {
    return {
      'id': id,
      'text': questionText,
      'answerA': answerA,
      'answerB': answerB,
      'answerC': answerC,
      'answerD': answerD,
      'correctAnswer': correctAnswer,
      'competition': competition.toJson(),
      'difficulty': difficulty,
      'year': year
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      correctAnswer: json['correctAnswer'],
      answerA: json['answerA'],
      answerB: json['answerB'],
      answerC: json['answerC'],
      answerD: json['answerD'],
      questionText: json['text'],
      competition:
          Competition.fromJson(json['competition'] as Map<String, dynamic>),
      year: json['year'],
      difficulty: json['difficulty'],
    );
  }
}
