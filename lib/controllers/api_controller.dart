import 'dart:io';

import 'package:footix/models/competition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/question.dart';

class APIController {
  var baseURL = 'http://10.0.2.2:8000';
  //var baseURL = 'http://192.168.0.178:8000';

  getQuestion(int questionId) async {
    var url = Uri.parse('$baseURL/question/$questionId');
    try {
      var questionData = jsonDecode(await get(url));
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
        year: questionData['year'].toInt(),
      );
      return question;
    } catch (e) {
      print('Error getting question: ${e.toString()}');
      return null;
    }
  }

  getCompetition(int competitionId) async {
    var url = Uri.parse('$baseURL/competition/$competitionId');
    try {
      var competitionData = jsonDecode(await get(url));

      Competition competition = Competition(
          id: competitionData['id'],
          name: competitionData['name'],
          code: competitionData['code'],
          logoPath: '$baseURL${competitionData['logo_path']}',
          reputation: competitionData['reputation']);

      return competition;
    } catch (e) {
      print('Error getting competitions: ${e.toString()}');
      return null;
    }
  }

  getCompetitions() async {
    var url = Uri.parse('$baseURL/competitions');
    try {
      var competitionData = jsonDecode(await get(url));
      var competitionList = [];
      for (var i = 0; i < competitionData.toList().length; i++) {
        Competition competition = Competition(
            id: competitionData[i]['id'],
            name: competitionData[i]['name'],
            code: competitionData[i]['code'],
            logoPath: '$baseURL${competitionData[i]['logo_path']}',
            reputation: competitionData[i]['reputation']);
        competitionList.add(competition);
      }

      return competitionList;
    } catch (e) {
      print('Error getting competitions: ${e.toString()}');
      return null;
    }
  }

  getCompetitionNames() async {
    var url = Uri.parse('$baseURL/competitions/names');
    try {
      var competitionNames = jsonDecode(await get(url));
      List<String> names = List<String>.from(competitionNames as List);
      return names;
    } catch (e) {
      print('Error getting competition names: ${e.toString()}');
      return null;
    }
  }

  getCompetitionsMaxExp() async {
    var url = Uri.parse('$baseURL/competitions/maxexp');
    try {
      var competitionMaxExp = jsonDecode(await get(url));
      return competitionMaxExp;
    } catch (e) {
      print('Error getting max competition exp: ${e.toString()}');
      return null;
    }
  }

  getQuestionsCount() async {
    var url = Uri.parse('$baseURL/questions/count');
    try {
      var responseBody = await get(url);
      return jsonDecode(responseBody);
    } catch (e) {
      print('Error getting questions count: ${e.toString()}');
      return null;
    }
  }

  getQuestionIds() async {
    var url = Uri.parse('$baseURL/questions/ids');
    try {
      var responseBody = await get(url);
      return jsonDecode(responseBody);
    } catch (e) {
      print('Error getting question ids: ${e.toString()}');
      return null;
    }
  }

  Future<String> get(Uri url) async {
    try {
      var response = await http.get(url);
      return response.body;
    } on SocketException {
      throw Exception('Failed to connect to the server');
    }
  }

  sendFormData(
    String questionText,
    int season,
    String answerA,
    String answerB,
    String answerC,
    String answerD,
    String correctAnswer,
    int competitionID,
  ) async {
    var url = Uri.parse('$baseURL/add-user-question');

    try {
      Map<String, dynamic> requestData = {
        'text': questionText,
        'season': season,
        'answerA': answerA,
        'answerB': answerB,
        'answerC': answerC,
        'answerD': answerD,
        'correctAnswer': correctAnswer,
        'competitionID': competitionID,
      };

      var requestBody = jsonEncode(requestData);
      print(requestBody);

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
      } else {
        print('Error sending form data: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Failed to connect to the server');
    } catch (e) {
      print('Error sending form data: $e');
    }
  }
}
