import 'package:footix/models/question.dart';
import '../models/question_base.dart';

class QuestionController {
  int questionNum = 0; // question counter
  int questionNumber = 0; // indicates which question should be displayed
  int questionListLength = 50;

  List getList() {
    return List<int>.generate(questionListLength, (i) => i + 1);
  }

  List indexList = [];

  Future<Question> getNextQuestion() async {
    if (indexList.isEmpty) indexList = getList();
    indexList.remove(questionNumber);
    List<Map> question;
    Question currentQuestion = Question(
        ID: 'ID',
        questionText: 'questionText',
        answerA: 'answerA',
        answerB: 'answerB',
        answerC: 'answerC',
        answerD: 'answerD',
        correctAnswer: 'correctAnswer',
        questionCode: 'questionCode',
        difficulty: 1);
    if (questionNum < questionListLength) {
      question = await QuestionBase().getQuestionList();
      questionListLength = question.length;
      currentQuestion = Question(
          ID: question[questionNumber]['ID'],
          questionText: question[questionNumber]['questionText'],
          answerA: question[questionNumber]['answerA'],
          answerB: question[questionNumber]['answerB'],
          answerC: question[questionNumber]['answerC'],
          answerD: question[questionNumber]['answerD'],
          correctAnswer: question[questionNumber]['correctAnswer'],
          imgSrc: question[questionNumber]['imgSrc'],
          questionCode: question[questionNumber]['questionCode'],
          difficulty: question[questionNumber]['difficulty']);
      return currentQuestion;
    }
    return currentQuestion;
  }
}
