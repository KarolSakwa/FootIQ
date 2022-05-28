import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/models/question.dart';
import 'package:footix/views/components/question_card.dart';
import 'package:uuid/uuid.dart';
import 'package:footix/contants.dart';

class DB {
  final firestoreInstance = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<dynamic> getCollectionData(String collection,
      [var specificField]) async {
    var fieldList = [];
    await firestoreInstance.collection(collection).get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        if (specificField != null) {
          fieldList.add(result.data()[specificField]);
        } else {
          fieldList.add(result.data());
        }
      }
    });
    return fieldList;
  }

  Future<dynamic> getCollectionDataField(
      String collection, String field, String fieldValue,
      [bool allResults = false]) async {
    var collectionDataField;
    await firestoreInstance
        .collection(collection)
        .where(field, isEqualTo: fieldValue)
        .get()
        .then((value) {
      if (value.docs.length > 1 && allResults) {
        collectionDataField = [];
        for (var i = 0; i < value.docs.length; i++) {
          collectionDataField.add(value.docs[i].data());
        }
      } else {
        collectionDataField = value.docs[0].data();
      }
    });
    return collectionDataField;
  }

  Future<dynamic> getCollectionDataFieldWithID(
      String collection, String field, String fieldValue,
      [bool allResults = false]) async {
    var finalMap;
    await firestoreInstance
        .collection(collection)
        .where(field, isEqualTo: fieldValue)
        .get()
        .then((value) {
      if (value.docs.length > 1 && allResults) {
        finalMap = [];
        for (var i = 0; i < value.docs.length; i++) {
          finalMap = value.docs[i].data();
          finalMap['docID'] = value.docs[i].id;
        }
      } else {
        finalMap = value.docs[0].data();
        finalMap['docID'] = value.docs[0].id;
      }
    });
  }

  Future<dynamic> getFieldData(
      String collection, String? documentID, String fieldName) async {
    var collectionDataField;
    await firestoreInstance
        .collection(collection)
        .where(FieldPath.documentId, isEqualTo: documentID)
        .get()
        .then((value) {
      collectionDataField = value.docs[0].data();
    });
    return collectionDataField[fieldName];
  }

// creates new field and assigning value to it
  String addData(String collection, Map<String, dynamic> data, {String? id}) {
    if (id == null) {
      var uuid = Uuid();
      id = uuid.v4();
    }
    Map<String, dynamic> dataMap = {};
    for (var i = 0; i < data.keys.length; i++) {
      String key = data.keys.toList()[i];
      var value = data.values.toList()[i];
      dataMap[key] = value;
    }
    firestoreInstance.collection(collection).doc(id).set(dataMap);
    return id;
  }

  void addMapData(String collection, String document, String mapName,
      Map<String, dynamic> data) async {
    var currentMap = await getFieldData(collection, document, mapName);
    for (var i = 0; i < data.keys.length; i++) {
      String key = data.keys.toList()[i];
      var value = data.values.toList()[i];
      currentMap[key] = value;
    }
    var finalMap = {mapName: currentMap};
    firestoreInstance.collection(collection).doc(document).update(finalMap);
  }

// updates existing field
  void updateData(String collection, String document, String field,
      Map<String, dynamic> data) {
    Map<String, dynamic> dataMap = {};
    for (var i = 0; i < data.keys.length; i++) {
      String key = data.keys.toList()[i];
      var value = data.values.toList()[i];
      dataMap[key] = value;
    }

    Map<String, Map> finalMap = {field: dataMap};
    firestoreInstance.collection(collection).doc(document).update(finalMap);
  }

  void incrementUserCompExp(String userID, String compName, double value) {
    firestoreInstance
        .collection('users')
        .doc(userID)
        .update({'exp.$compName': FieldValue.increment(value)});
  }

  void incrementMapValue(String collection, String document, String map,
      String mapField, double value,
      [String? nestedMapField]) {
    if (nestedMapField == '') {
      firestoreInstance
          .collection(collection)
          .doc(document)
          .update({'$map.$mapField': FieldValue.increment(value)});
    } else {
      firestoreInstance.collection(collection).doc(document).update(
          {'$map.$mapField.$nestedMapField': FieldValue.increment(value)});
    }
  }

  void appendMapValue(String collection, String document, String map,
      String mapField, var value,
      [String? nestedMapField]) {
    firestoreInstance
        .collection(collection)
        .doc(document)
        .update({'$map.$mapField': value});
  }

  Future<double> getTotalCompetitionExp(
      {required String competitionCode}) async {
    double result = 0;
    await firestoreInstance
        .collection(kQuestionDBTable)
        .where(
          'docCode',
          isGreaterThanOrEqualTo: competitionCode,
          isLessThan: competitionCode.substring(0, competitionCode.length - 1) +
              String.fromCharCode(
                  competitionCode.codeUnitAt(competitionCode.length - 1) + 1),
        )
        .get()
        .then((value) {
      for (var i = 0; i < value.size; i++) {
        double difficulty = value.docs[i].data()['difficulty'] ?? 0;
        result += difficulty;
      }
    });
    return result;
  }

  Future<dynamic> getMaximumExpCompetitionsMap() async {
    var finalMap = {};
    var allCompetitions = await getCollectionData('competition');
    for (var i = 0; i < allCompetitions.length; i++) {
      var current = allCompetitions[i];
      var compResult =
          await getTotalCompetitionExp(competitionCode: current['tm_code']);
      finalMap[current['tm_code']] = compResult;
    }
    return finalMap;
  }

  getAnswerCorrectnessMap(String? userID) async {
    var allUserChallenges = await getCollectionDataField(
        'challenges', 'user', _auth.currentUser!.uid, true);
    Map<String, double> answerCorrectness = {
      'askedTimesTotal': 0,
      'answeredCorrectlyTotal': 0
    };
    for (var i = 0; i < allUserChallenges.length; i++) {
      for (var j = 0; j < allUserChallenges[i]['questions'].length; j++) {
        answerCorrectness['askedTimesTotal'] =
            (answerCorrectness['askedTimesTotal']! + 1);
        var current = allUserChallenges[i]['questions']
            [allUserChallenges[i]['questions'].keys.toList()[j]];
        if (current == true) {
          answerCorrectness['answeredCorrectlyTotal'] =
              (answerCorrectness['answeredCorrectlyTotal']! + 1);
        }
      }
    }

    return answerCorrectness;
  }

  getDocumentIDWhereFieldEquals(
      String collection, String field, String fieldValue,
      [bool allResults = false]) async {
    var collectionDataField;
    await firestoreInstance
        .collection(collection)
        .where(field, isEqualTo: fieldValue)
        .get()
        .then((value) {
      if (value.docs.length > 1 && allResults) {
        collectionDataField = [];
        for (var i = 0; i < value.docs.length; i++) {
          collectionDataField.add(value.docs[i].id);
        }
      } else {
        collectionDataField = value.docs[0].id;
      }
    });
    return collectionDataField;
  }

  getUserAnsweredQuestions() async {
    var allUserAnsweredChallenges = await getDocumentIDWhereFieldEquals(
        'challenges', 'user', _auth.currentUser!.uid, true);
    var allUserAnsweredQuestions = [];
    for (var i = 0; i < allUserAnsweredChallenges.length; i++) {
      var currentQuestions = await getFieldData(
          'challenges', allUserAnsweredChallenges[i], 'questions');
      allUserAnsweredQuestions.add(currentQuestions);
    }
    Map finalMap = {};
    for (var i = 0; i < allUserAnsweredQuestions.length; i++) {
      finalMap.addAll(allUserAnsweredQuestions[i]);
    }
    return finalMap;
  }

  getUserAnsweredQuestionsByComp() async {
    // retrieving all user's questions
    var allUserAnsweredQuestions = await getUserAnsweredQuestions();
    var finalMap = {};
    for (var i = 0; i < allUserAnsweredQuestions.keys.toList().length; i++) {
      var currentQuestionCode = await getFieldData(kQuestionDBTable,
          allUserAnsweredQuestions.keys.toList()[i], 'docCode');
      String currentQuestionCodeSanitized =
          currentQuestionCode.substring(0, currentQuestionCode.indexOf('_'));
      if (finalMap[currentQuestionCodeSanitized] == null) {
        finalMap[currentQuestionCodeSanitized] = [];
      }

      finalMap[currentQuestionCodeSanitized].add({
        allUserAnsweredQuestions.keys.toList()[i]:
            allUserAnsweredQuestions[allUserAnsweredQuestions.keys.toList()[i]]
      });
    }
    return finalMap;
  }
}
