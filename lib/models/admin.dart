import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:web_scraper/web_scraper.dart';
import "dart:math";

import '../contants.dart';
import 'firebase_service.dart';

class Admin {
  final firestoreInstance = FirebaseFirestore.instance;
  final _random = new Random();
  final firebaseService = FirebaseService();
  var uuid = Uuid();

  // tm

  String competitionProfileUrl =
      '/premier-league/startseite/wettbewerb/|competition|';

  // FUNCTIONS INSERTING QUESTIONS
  // best scorers in given competition in specific season
  void QuestionsScorersByCompetitionSeason() async {
    // retrieving competitions from db
    int firstSeason = 1992;
    int lastSeason = 2020;
    var competitions = await firebaseService.getCollectionData('competition');
    List<int> seasons = [];
    for (var i = firstSeason; i <= lastSeason; i++) {
      seasons.add(i);
    }

    final webScraper = WebScraper('https://www.transfermarkt.com');
    String docCode = '';
    for (var i = 0; i < competitions.length; i++) {
      Map currentCompetition = competitions[i];
      String currentCompetitionCode = competitions[i]['tm_code'];
      for (var season in seasons) {
        String competitionScorersUrl =
            '/premier-league/torschuetzenliste/wettbewerb/|competition|/saison_id/|season|';
        String docID = uuid.v1();
        docCode = currentCompetitionCode + '_' + season.toString();
        double difficulty = double.parse(
            (currentCompetition['reputation'] + getYearDifficultyRating(season))
                .toStringAsExponential(1));
        competitionScorersUrl = competitionScorersUrl.replaceAll(
            '|competition|', currentCompetitionCode);
        competitionScorersUrl =
            competitionScorersUrl.replaceAll('|season|', season.toString());
        if (await webScraper.loadWebPage(competitionScorersUrl)) {
          final playersUnits = webScraper.getElement(
              '#yw1 > table > tbody > tr > td.zentriert.hauptlink > a',
              ['title']);
          var playersList = [playersUnits[0]];
          // SPRAWDZAM, CZY DRUGI NAJLEPSZY NA PEWNO MA MNIEJ OD PIERWSZEGO - JEŚLI TYLE SAMO, TO GO NIE UWZGLĘDNIAM
          for (var player in playersUnits.sublist(1, 10)) {
            if (int.parse(player['title']) <
                int.parse(playersUnits[0]['title'])) {
              playersList.add(player);
            }
          }
          var finalList = playersList.take(4);

          Future<void> addUser(questionText) async {
            List<String> answerList = ['a', 'b', 'c', 'd'];

            // adding answer options
            Map DataMap = {
              'correct_answer': playersList[0]['attributes']['title']
            };
            for (var player in finalList) {
              var element = answerList[_random.nextInt(answerList.length)];
              DataMap["answer_$element"] = player['attributes']['title'];
              answerList.remove(element);
            }
            // adding question body and correct answer
            DataMap["question_text"] = questionText;
            firestoreInstance.collection(kQuestionDBTable).doc(docID).set({
              'ID': docID,
              'correct_answer': DataMap['correct_answer'],
              'answer_a': DataMap['answer_a'],
              'answer_b': DataMap['answer_b'],
              'answer_c': DataMap['answer_c'],
              'answer_d': DataMap['answer_d'],
              'question_text': DataMap['question_text'],
              'docCode': docCode,
              'difficulty': difficulty
            });
          }

          String questionBase =
              'Who scored the most goals in |competition| |season| season?';
          questionBase = questionBase.replaceAll(
              '|competition|', currentCompetition['name']);
          questionBase = questionBase.replaceAll(
              '|season|', season.toString() + '-' + (season + 1).toString());
          addUser(questionBase);
        } else {
          print('Cannot load url');
        }
      }
    }
  }

  // HELPERS

  double getYearDifficultyRating(int year) {
    // the older the question is, the higher the difficulty level
    double initialRating = 1;
    for (var i = 2022; i > year; i--) {
      initialRating += 0.3;
    }
    return initialRating;
  }
}
