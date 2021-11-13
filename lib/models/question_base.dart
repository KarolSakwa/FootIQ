// this file is here to simulate database
import 'question.dart';

class QuestionBase {
  List<Map> questionList = [
    {
      'questionText': 'YU?',
      'answerA': 'A',
      'answerB': 'B',
      'answerC': 'C',
      'answerD': 'D',
      'correctAnswer': 'C',
      'imgSrc': 'assets/question_images/cash.jpg'
    },
    {
      'questionText': 'Who\'s that?',
      'answerA': 'Dani Alves',
      'answerB': 'Diego Alves',
      'answerC': 'Cani',
      'answerD': 'Doopa',
      'correctAnswer': 'Dani Alves',
      'imgSrc': 'assets/question_images/danialves.jpg'
    }
  ];
}
