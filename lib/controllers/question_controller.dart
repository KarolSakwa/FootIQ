import 'package:footix/models/question.dart';
import '../models/database.dart';
import '../models/question_base.dart';

class QuestionController {
  int questionNum = 0; // question counter
  int questionNumber = 0; // indicates which question should be displayed
  int questionListLength = 50;
  final db = DB();

  List getList() {
    return List<int>.generate(questionListLength, (i) => i + 1);
  }

  List indexList = [];

  Future<Question> getNextQuestion() async {
    // jest problem wynikający z odświeżania całego ekranu quizu co sekundę - obszedłem to tak, że co sekundę pobiera się to samo pytanie
    var questionData = await db.getNextQ();

    Question currentQuestion = Question(
        ID: questionData['ID'],
        questionText: questionData['question_text'],
        answerA: questionData['answer_a'],
        answerB: questionData['answer_b'],
        answerC: questionData['answer_c'],
        answerD: questionData['answer_d'],
        correctAnswer: questionData['correct_answer'],
        questionCode: questionData['docCode'],
        difficulty: questionData['difficulty']);
    // if (questionNum < questionListLength) {
    //   question = await QuestionBase().getQuestionList();
    //   questionListLength = question.length;
    //   currentQuestion = Question(
    //       ID: question[questionNumber]['ID'],
    //       questionText: question[questionNumber]['questionText'],
    //       answerA: question[questionNumber]['answerA'],
    //       answerB: question[questionNumber]['answerB'],
    //       answerC: question[questionNumber]['answerC'],
    //       answerD: question[questionNumber]['answerD'],
    //       correctAnswer: question[questionNumber]['correctAnswer'],
    //       imgSrc: question[questionNumber]['imgSrc'],
    //       questionCode: question[questionNumber]['questionCode'],
    //       difficulty: question[questionNumber]['difficulty']);
    //   return currentQuestion;
    // }
    return currentQuestion;
  }
}
