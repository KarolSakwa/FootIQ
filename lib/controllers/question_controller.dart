import 'dart:math';

import 'package:footix/controllers/api_controller.dart';
import 'package:footix/models/question.dart';
import 'package:footix/repository/answered_questions_repository.dart';
import '../models/firebase_service.dart';
import 'data_cache_controller.dart';

class QuestionController {
  int questionNum = 0; // question counter
  int questionListLength = 50;
  var firebaseService = FirebaseService();
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

    int unsuccessfulAttempts = 0;
    int maxAttempts = 100;

    while (questionList.length < questionSetSize) {
      var questionId =
          await getNextQuestionID(); // Używamy metody getNextQuestion() zamiast currentIndex

      var question = await dataCacheController.getQuestionData(questionId);
      if (question != null) {
        questionList.add(question);
        unsuccessfulAttempts = 0; // Reset the counter
      } else {
        question = await apiController.getQuestion(questionId);
        if (question != null) {
          await dataCacheController.cacheQuestionData(question);
          questionList.add(question);
          unsuccessfulAttempts = 0; // Reset the counter
        } else {
          unsuccessfulAttempts++;
          print(
              'Unsuccessful attempt $unsuccessfulAttempts to retrieve question $questionId');
          if (unsuccessfulAttempts >= maxAttempts) {
            print('Reached the maximum number of unsuccessful attempts');
            break;
          }
        }
      }
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

  Future<int> getNextQuestionID() async {
    var questionIds = await apiController.getQuestionIds();
    var answeredQuestionRepository = AnsweredQuestionsRepository();
    var answeredQuestions = await answeredQuestionRepository
        .getUserAnsweredQuestionsList(firebaseService.auth.currentUser!.uid);

    var questionFrequency = {};
    questionIds.forEach((questionId) {
      if (!answeredQuestions.contains(questionId)) {
        questionFrequency[questionId] =
            (questionFrequency[questionId] ?? 0) + 1;
      }
    });

    var leastFrequentQuestions = [];
    var leastFrequency = questionFrequency.values
        .reduce((min, value) => value < min ? value : min);
    questionFrequency.forEach((questionId, frequency) {
      if (frequency == leastFrequency) {
        leastFrequentQuestions.add(questionId);
      }
    });

    if (leastFrequentQuestions.isNotEmpty) {
      var random = Random();
      var randomQuestionIndex = random.nextInt(leastFrequentQuestions.length);
      return leastFrequentQuestions[randomQuestionIndex];
    }

    return -1;
  }
}
