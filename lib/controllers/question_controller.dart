import 'dart:collection';
import 'dart:math';

import 'package:footix/models/question.dart';
import 'package:footix/views/components/question_card.dart';

import '../models/database.dart';
import '../models/question_base.dart';

class QuestionController {
  // int questionNum = 0;
  // int questionNumber = 0;
  // int questionListLength = 50;
  // final db = DB();
  // final _random = Random();
  //
  // Future<Question> getNextQuestion2() async {
  //   var allUserAskedQuestions = await getAllUserAskedQuestionMap();
  //   var allQuestions = await db.getCollectionData('new_final_questions');
  //   var element = allQuestions[_random.nextInt(allQuestions.length)];
  //   var chosenElement;
  //
  //   for (var i = 0; i < 100; i++) {
  //     if (!allUserAskedQuestions!.keys.toList().contains(element['ID'])) {
  //       chosenElement = element;
  //     } else {
  //       var sortedKeys = allUserAskedQuestions!.keys.toList(growable: false)
  //         ..sort((k1, k2) => allUserAskedQuestions[k1]!
  //             .compareTo(allUserAskedQuestions[k2] as num));
  //       LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
  //           key: (k) => k, value: (k) => allUserAskedQuestions[k]);
  //       chosenElement = sortedMap[sortedMap.keys.toList()[0]];
  //     }
  //   }
  //
  //   Question currentQuestion = Question(
  //       ID: chosenElement['ID'],
  //       questionText: chosenElement['question_text'],
  //       answerA: chosenElement['answer_a'],
  //       answerB: chosenElement['answer_b'],
  //       answerC: chosenElement['answer_c'],
  //       answerD: chosenElement['answer_d'],
  //       correctAnswer: chosenElement['correct_answer'],
  //       questionCode: chosenElement['docCode'],
  //       difficulty: chosenElement['difficulty']);
  //   return currentQuestion;
  // }
  //
  // // Future<Question> getNextQuestion2() async {
  // //   if (indexList.isEmpty) indexList = getList();
  // //   indexList.remove(questionNumber);
  // //   List<Map> question;
  // //   Question currentQuestion = Question(
  // //       ID: 'ID',
  // //       questionText: 'questionText',
  // //       answerA: 'answerA',
  // //       answerB: 'answerB',
  // //       answerC: 'answerC',
  // //       answerD: 'answerD',
  // //       correctAnswer: 'correctAnswer',
  // //       questionCode: 'questionCode',
  // //       difficulty: 1);
  // //   if (questionNum < questionListLength) {
  // //     question = await QuestionBase().getQuestionList();
  // //     questionListLength = question.length;
  // //     currentQuestion = Question(
  // //         ID: question[questionNumber]['ID'],
  // //         questionText: question[questionNumber]['questionText'],
  // //         answerA: question[questionNumber]['answerA'],
  // //         answerB: question[questionNumber]['answerB'],
  // //         answerC: question[questionNumber]['answerC'],
  // //         answerD: question[questionNumber]['answerD'],
  // //         correctAnswer: question[questionNumber]['correctAnswer'],
  // //         imgSrc: question[questionNumber]['imgSrc'],
  // //         questionCode: question[questionNumber]['questionCode'],
  // //         difficulty: question[questionNumber]['difficulty']);
  // //     return currentQuestion;
  // //   }
  // //   return currentQuestion;
  // // }
  //
  // Future<Map<String, int>?> getAllUserAskedQuestionMap() async {
  //   var allUserChallenges = await db.getCollectionDataField(
  //       'challenges', 'user', loggedInUser.uid, true);
  //   Map<String, int> allUserQuestionsAsked = {};
  //   for (var i = 0; i < allUserChallenges.length; i++) {
  //     for (var j = 0;
  //         j < allUserChallenges[i]['questions'].keys.toList().length;
  //         j++) {
  //       String currentKey = allUserChallenges[i]['questions'].keys.toList()[j];
  //       if (allUserQuestionsAsked[currentKey] == null) {
  //         allUserQuestionsAsked[currentKey] = 0;
  //       }
  //       allUserQuestionsAsked[currentKey] =
  //           (allUserQuestionsAsked[currentKey]! + 1);
  //     }
  //   }
  //   return allUserQuestionsAsked;
  // }

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
