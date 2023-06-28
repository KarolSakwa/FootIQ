import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:footix/controllers/api_controller.dart';
import 'package:footix/controllers/data_cache_controller.dart';

import '../controllers/question_controller.dart';
import '../models/question.dart';

class AnsweredQuestionsRepository {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  APIController apiController = APIController();
  DataCacheController dataCacheController = DataCacheController();
  QuestionController questionController = QuestionController();

  AnsweredQuestionsRepository();

  getUserAnsweredQuestions(String userId) async {
    final userDoc =
        await firestoreInstance.collection('users').doc(userId).get();
    return userDoc.data()?['answeredQuestions'];
  }

  getUserAnsweredQuestionsList(String userId) async {
    final answeredQuestions = await getUserAnsweredQuestions(userId);
    var allAnsweredQuestionsList = [];
    answeredQuestions.forEach((key, value) {
      allAnsweredQuestionsList.addAll(value);
    });
    return allAnsweredQuestionsList;
  }

  divideIntoCompetitions(answeredQuestions) async {
    final dividedCompetitions = {};
    for (final result in answeredQuestions.keys) {
      final questionIds = answeredQuestions[result] ?? [];
      for (final questionId in questionIds) {
        final question =
            await questionController.getQuestion(int.parse(questionId));
        if (question != null && question.competition != null) {
          final competitionId = question.competition.id;
          final competitionName = question.competition.name;
          dividedCompetitions[competitionId] ??= {
            'name': competitionName,
            'correct': [],
            'incorrect': []
          };
          dividedCompetitions[competitionId][result]?.add(questionId);
        }
      }
    }
    return dividedCompetitions;
  }

  Future<Map<int, double>> getUserGainedExpCompetitionMap(String userId) async {
    var answeredQuestions = await getUserAnsweredQuestions(userId);
    Map<int, double> gainedExpCompetitionMap = {};

    for (var result in answeredQuestions.keys.toList()) {
      for (var questionId in answeredQuestions[result]) {
        Question question =
            await dataCacheController.getQuestionData(int.parse(questionId)) ??
                await apiController.getQuestion(int.parse(questionId));

        if (question != null) {
          await dataCacheController.cacheQuestionData(question);

          if (result == 'correct') {
            gainedExpCompetitionMap[question.competition.id] =
                (gainedExpCompetitionMap[question.competition.id] ?? 0.0) +
                    question.difficulty * 2;
          } else {
            gainedExpCompetitionMap[question.competition.id] =
                (gainedExpCompetitionMap[question.competition.id] ?? 0.0) -
                    question.difficulty;
          }
        } else {
          print('Error: Question is null.');
        }
      }
    }

    return gainedExpCompetitionMap;
  }

  Future<double> getUserGainedExpTotal(String userId) async {
    var answeredQuestions = await getUserAnsweredQuestions(userId);
    double totalExp = 0.0;
    QuestionController questionController = QuestionController();

    for (var result in answeredQuestions.keys.toList()) {
      for (var questionId in answeredQuestions[result]) {
        Question? question =
            await questionController.getQuestion(int.parse(questionId));

        if (question != null) {
          await dataCacheController.cacheQuestionData(question);

          if (result == 'correct') {
            totalExp += question.difficulty * 2;
          } else {
            totalExp -= question.difficulty;
          }
        } else {
          print('Error: Question is null.');
        }
      }
    }

    return totalExp;
  }

  Future<int> getAnswerCountForQuestion(String userId, int questionId) async {
    final answeredQuestions = await getUserAnsweredQuestions(userId);
    int count = 0;

    for (final result in answeredQuestions.keys.toList()) {
      for (final answeredQuestionId in answeredQuestions[result]) {
        if (int.parse(answeredQuestionId) == questionId) {
          count++;
        }
      }
    }

    return count;
  }
}
