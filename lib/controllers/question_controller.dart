import 'package:footix/controllers/api_controller.dart';
import 'package:footix/models/question.dart';
import '../models/database.dart';
import 'dart:math';

class QuestionController {
  int questionNum = 0; // question counter
  int questionListLength = 50;
  final db = DB();
  APIController apiController = APIController();

  /// Returns a random question
  Future<Question> getRandomQuestion() async {
    var question =
        await apiController.getQuestion(2); // TODO: ZMIENIĆ NA DYNAMICZNE
    return question;
  }

  /// Returns a full question set
  Future<List<Question>> getQuestionSet() async {
    int questionSetSize = 5;
    List<Question> questionList = [];
    var i = 0;
    while (questionList.length < questionSetSize) {
      var question;
      while (question == null) {
        try {
          question = await apiController.getQuestion(i);
        } catch (e) {
          print('Failed to get question $i: $e');
          question = null;
        }
        i++;
      }
      questionList.add(question);
    }

    if (questionList.length < questionSetSize) {
      print('ERROR! Set not build properly!');
    }

    return questionList;
  }

  getAllUserAnsweredQuestions() async {
    var test = await db.getCollectionDataField(
        'challenges', 'user', '1r6NTNyxoffkZTHqP7FGUcdP2eC2', true);
    var allAnsweredQuestionsMap = {};
    for (var i = 0; i < test.length; i++) {
      var currentChallengeQuestions = test[i]['questions'];
      if (currentChallengeQuestions.length > 0) {
        for (var j = 0; j < currentChallengeQuestions.length; j++) {
          allAnsweredQuestionsMap[currentChallengeQuestions.keys.toList()[j]] =
              currentChallengeQuestions[
                  currentChallengeQuestions.keys.toList()[j]];
        }
      }
    }
    return allAnsweredQuestionsMap;
  }
}
