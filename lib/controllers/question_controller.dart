import 'package:footix/controllers/api_controller.dart';
import 'package:footix/models/question.dart';
import '../models/firebase_service.dart';
import 'data_cache_controller.dart';

class QuestionController {
  int questionNum = 0; // question counter
  int questionListLength = 50;
  final firebaseService = FirebaseService();
  APIController apiController = APIController();
  DataCacheController dataCacheController = DataCacheController();

  /// Returns a random question
  Future<Question> getRandomQuestion() async {
    Question? question = await dataCacheController.getQuestionData(questionNum);
    if (question != null) {
      return question;
    }

    question = await apiController.getQuestion(questionNum);

    await dataCacheController.cacheQuestionData(question!);

    return question;
  }

  /// Returns a full question set
  Future<List<Question>> getQuestionSet() async {
    int questionSetSize = 5;
    List<Question> questionList = [];

    int currentIndex = 0;
    int unsuccessfulAttempts = 0;
    int maxAttempts = 100;

    while (questionList.length < questionSetSize) {
      var question = await dataCacheController.getQuestionData(currentIndex);
      if (question != null) {
        questionList.add(question);
        unsuccessfulAttempts = 0; // Reset the counter
      } else {
        question = await apiController.getQuestion(currentIndex);
        if (question != null) {
          await dataCacheController.cacheQuestionData(question);
          questionList.add(question);
          unsuccessfulAttempts = 0; // Reset the counter
        } else {
          unsuccessfulAttempts++;
          print(
              'Unsuccessful attempt $unsuccessfulAttempts to retrieve question $currentIndex');
          if (unsuccessfulAttempts >= maxAttempts) {
            print('Reached the maximum number of unsuccessful attempts');
            break; // Exit the loop
          }
        }
      }
      currentIndex++;
    }

    return questionList;
  }

  /// Retrieves a question by ID
  Future<Question?> getQuestion(int id) async {
    Question? question = await dataCacheController.getQuestionData(id);
    if (question != null) {
      return question;
    }

    question = await apiController.getQuestion(id);

    if (question != null) {
      await dataCacheController.cacheQuestionData(question);
    }

    return question;
  }

  getAllUserAnsweredQuestions() async {
    var test = await firebaseService.getCollectionDataField(
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
