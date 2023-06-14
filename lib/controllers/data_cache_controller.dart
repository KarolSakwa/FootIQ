import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../models/competition.dart';
import '../models/question.dart';
import '../controllers/api_controller.dart';
import 'dart:typed_data';

class DataCacheController {
  final cacheManager = DefaultCacheManager();
  final apiController = APIController();

  Future<void> cacheQuestionData(Question question) async {
    final questionKey = 'question_${question.id}';
    final competitionKey = 'competition_${question.competition.id}';

    final questionJson = jsonEncode(question.toJson());
    final questionBytes = Uint8List.fromList(utf8.encode(questionJson));
    await cacheManager.putFile(questionKey, questionBytes);

    final competitionJson = jsonEncode(question.competition.toJson());
    final competitionBytes = Uint8List.fromList(utf8.encode(competitionJson));
    await cacheManager.putFile(competitionKey, competitionBytes);
  }

  Future<Question?> getQuestionData(int questionId) async {
    final questionKey = 'question_$questionId';

    final questionFile = await cacheManager.getFileFromCache(questionKey);
    if (questionFile != null && questionFile.file != null) {
      final questionData = await questionFile.file.readAsBytes();
      final questionJson = utf8.decode(questionData);
      final question = Question.fromJson(jsonDecode(questionJson));

      return question;
    }

    return null;
  }
}
