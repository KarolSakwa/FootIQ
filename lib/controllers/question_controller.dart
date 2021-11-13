import 'package:footix/models/question.dart';
import 'package:footix/models/question_base.dart';

class QuestionController {
  int questionNum = 0;
  int _maxQuestionNum = 15;
  List<Map> questionList = QuestionBase().questionList;

  Question getNextQuestion() {
    // HERE IS WHERE I AM GOING TO RETRIEVE THE DATA FROM DB
    if (questionNum < _maxQuestionNum) {
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
    throw Exception('There\'s no more questions left!');
  }
}
