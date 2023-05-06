import 'package:footix/models/competition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/question.dart';

class APIController {
  static const String baseURL = 'http://10.0.2.2:8000';

  Future<Question> getQuestion(int questionId) async {
    var url = Uri.parse('$baseURL/question/$questionId');
    var questionData = jsonDecode(await _get(url));
    var competition = await getCompetition(questionData['competition']);

    Question question = Question(
        id: questionData['id'],
        questionText: questionData['text'],
        answerA: questionData['answerA'],
        answerB: questionData['answerB'],
        answerC: questionData['answerC'],
        answerD: questionData['answerD'],
        correctAnswer: questionData['correctAnswer'],
        competition: competition,
        difficulty: questionData['difficulty'].toDouble(),
        year: questionData['year'].toInt());
    return question;
  }

  Future<Competition> getCompetition(int competitionId) async {
    var url = Uri.parse('$baseURL/competition/$competitionId');
    var competitionData = jsonDecode(await _get(url));

    Competition competition = Competition(
        id: competitionData['id'],
        name: competitionData['name'],
        code: competitionData['code'],
        logoPath: '$baseURL${competitionData['logo_path']}',
        reputation: competitionData['reputation']);

    return competition;
  }

  Future<int> getQuestionsCount() async {
    var url = Uri.parse('$baseURL/questions/count');
    var responseBody = await _get(url);

    return jsonDecode(responseBody);
  }

  Future<String> _get(Uri url) async {
    var response = await http.get(url);
    return response.body;
  }
}
