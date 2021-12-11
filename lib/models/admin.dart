import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_scraper/web_scraper.dart';
import "dart:math";

class Admin {
  final firestoreInstance = FirebaseFirestore.instance;
  final _random = new Random();

  // random string generator
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  // tm

  String competitionProfileUrl =
      '/premier-league/startseite/wettbewerb/|competition|';

  //

  Future<dynamic> getCollectionData(String collection) async {
    Map collectionMap = {};
    await firestoreInstance.collection(collection).get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        collectionMap[result.data()['tm_code']] = result.data()['name'];
      }
    });
    return collectionMap;
  }

  void insertQuestionsToDB() async {
    // pobranie z bazy rozgrywek

    int firstSeason = 1992;
    int lastSeason = 2020;
    Map competitions = await getCollectionData('competition');
    List<int> seasons = [];
    for (var i = firstSeason; i <= lastSeason; i++) {
      seasons.add(i);
    }

    final webScraper = WebScraper('https://www.transfermarkt.com');
    String docCode = '';
    for (var competition in competitions.keys) {
      for (var season in seasons) {
        String competitionScorersUrl =
            '/premier-league/torschuetzenliste/wettbewerb/|competition|/saison_id/|season|';
        String docID = getRandomString(20);
        docCode = competition + '_' + season.toString();
        print(docCode);
        competitionScorersUrl =
            competitionScorersUrl.replaceAll('|competition|', competition);
        competitionScorersUrl =
            competitionScorersUrl.replaceAll('|season|', season.toString());
        print(competitionScorersUrl);
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

            // DODAJĘ OPCJE ODPOWIEDZI
            Map DataMap = {
              'correct_answer': playersList[0]['attributes']['title']
            };
            for (var player in finalList) {
              var element = answerList[_random.nextInt(answerList.length)];
              DataMap["answer_$element"] = player['attributes']['title'];
              answerList.remove(element);
            }
            // DODAJĘ TEKST PYTANIA I POPRAWNĄ ODP
            DataMap["question_text"] = questionText;
            firestoreInstance.collection('final_questions').doc(docID).set({
              'correct_answer': DataMap['correct_answer'],
              'answer_a': DataMap['answer_a'],
              'answer_b': DataMap['answer_b'],
              'answer_c': DataMap['answer_c'],
              'answer_d': DataMap['answer_d'],
              'question_text': DataMap['question_text'],
              'docCode': docCode,
              'question_category': competition
            });
          }

          String questionBase =
              'Who scored the most goals in |competition| |season| season?';
          questionBase = questionBase.replaceAll(
              '|competition|', competitions[competition]);
          questionBase = questionBase.replaceAll(
              '|season|', season.toString() + '-' + (season + 1).toString());
          addUser(questionBase);
        } else {
          print('Cannot load url');
        }
      }
    }
  }
}
