import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/controllers/api_controller.dart';
import 'package:footix/controllers/question_controller.dart';
import 'package:footix/repository/answered_questions_repository.dart';
import 'package:footix/views/components/question_card.dart';
import 'package:uuid/uuid.dart';
import 'package:footix/contants.dart';
import 'dart:math';

class FirebaseService {
  final firestoreInstance = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  APIController apiController = APIController();

  /// Returns list of items in given collection
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
      if (value.size > 0) {
        if (allResults) {
          collectionDataField = [];
          for (var i = 0; i < value.docs.length; i++) {
            collectionDataField.add(value.docs[i].data());
          }
        } else {
          collectionDataField = value.docs[0].data();
        }
      } else {
        print('No data returned by getCollectionDataField');
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

  /// Returns field data of a given 'fieldName' of a given 'documentID'
  Future<dynamic> getFieldData(
      String collection, String? documentID, String fieldName) async {
    var collectionDataField;
    await firestoreInstance
        .collection(collection)
        .where(FieldPath.documentId, isEqualTo: documentID)
        .get()
        .then((value) {
      if (value.size > 0) {
        collectionDataField = value.docs[0].data();
      } else {
        print(
            'No data returned by getFieldData: collection - $collection, documentID - $documentID, fieldName - $fieldName');
      }
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

  Future<void> appendToCorrectArray(String userId, String value) async {
    final userDocRef = firestoreInstance.collection('users').doc(userId);

    await firestoreInstance.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userDocRef);
      final answeredQuestions = userSnapshot.data()?['answeredQuestions'];

      List<String> updatedCorrectArray;

      if (answeredQuestions != null && answeredQuestions['correct'] != null) {
        updatedCorrectArray = [...answeredQuestions['correct'], value];
      } else {
        updatedCorrectArray = [value];
      }

      transaction.update(
          userDocRef, {'answeredQuestions.correct': updatedCorrectArray});
    });
  }

  Future<void> appendToIncorrectArray(String userId, String value) async {
    final userDocRef = firestoreInstance.collection('users').doc(userId);

    await firestoreInstance.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userDocRef);
      final answeredQuestions = userSnapshot.data()?['answeredQuestions'];

      List<String> updatedIncorrectArray;

      if (answeredQuestions != null && answeredQuestions['incorrect'] != null) {
        updatedIncorrectArray = [...answeredQuestions['incorrect'], value];
      } else {
        updatedIncorrectArray = [value];
      }

      transaction.update(
          userDocRef, {'answeredQuestions.incorrect': updatedIncorrectArray});
    });
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
      [String? nestedMapField, String? nestedInsideNestedMapField]) {
    if (nestedMapField == '') {
      firestoreInstance
          .collection(collection)
          .doc(document)
          .update({'$map.$mapField': FieldValue.increment(value)});
    } else {
      firestoreInstance.collection(collection).doc(document).update(
          {'$map.$mapField.$nestedMapField': FieldValue.increment(value)});
    }
    // if (nestedInsideNestedMapField != '') {
    //   firestoreInstance.collection(collection).doc(document).update(
    //       {'$map.$mapField.$nestedMapField': FieldValue.increment(value)});
    // }
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
    var allUserChallenges =
        await getCollectionDataField('challenges', 'user', userID!, true);
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

  /// Returns all or one documents where 'field' is equal to 'fieldValue'
  getDocumentIDWhereFieldEquals(
      String collection, String field, String fieldValue,
      [bool allResults = false]) async {
    var collectionDataField;
    try {
      await firestoreInstance
          .collection(collection)
          .where(field, isEqualTo: fieldValue)
          .get()
          .then((value) {
        if (allResults) {
          collectionDataField = [];
          for (var i = 0; i < value.docs.length; i++) {
            collectionDataField.add(value.docs[i].id);
          }
        } else {
          collectionDataField = value.docs[0].id;
        }
      });
      return collectionDataField;
    } on Exception catch (e) {
      print('ERROR $e');
    }
  }

  getUserAnsweredQuestions([String? userID]) async {
    final DocumentSnapshot documentSnapshot =
        await firestoreInstance.collection("users").doc(userID).get();
    var answeredQuestions = documentSnapshot.get("answeredQuestions");
    return answeredQuestions;
  }

  getUserAnsweredQuestionsTotalExp(String userID) async {
    var questionController = QuestionController();
    var answeredQuestions = await getUserAnsweredQuestions(userID);
    double totalExp = 0;
    for (var questionID in answeredQuestions.keys) {
      var question = await questionController.getQuestion(questionID);
      if (question!.getQuestionDifficulty() != null &&
          answeredQuestions[questionID]["correct"] != null) {
        totalExp += (question.getQuestionDifficulty() *
                answeredQuestions[questionID]["correct"])
            .toDouble();
      }
    }
    return totalExp;
  }

  Future<List<Map<String, dynamic>>> getGlobalRanking() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> ranking = [];

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      String userId = documentSnapshot.id;
      var userExp = await getUserAnsweredQuestionsTotalExp(userId);
      ranking.add({userId: userExp});
    }

    ranking
        .sort((a, b) => (b.values.first as double).compareTo(a.values.first));
    return ranking;
  }

  Future<List<Map<String, dynamic>>> getUserRanking(String userId) async {
    AnsweredQuestionsRepository answeredQuestionsRepository =
        AnsweredQuestionsRepository();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<Map<String, dynamic>> ranking = [];

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      String currUserId = documentSnapshot.id;
      var userExp =
          await answeredQuestionsRepository.getUserGainedExpTotal(currUserId);
      ranking.add({
        currUserId: {'exp': userExp}
      });
    }

    ranking.sort((a, b) => (b.values.first['exp'] as double)
        .compareTo(a.values.first['exp'] as double));

    int userPosition =
        ranking.indexWhere((element) => element.keys.first == userId);

    int start = userPosition - 2 >= 0 ? userPosition - 2 : 0;
    int end = userPosition + 2 < ranking.length
        ? userPosition + 2
        : ranking.length - 1;

    for (int i = start; i <= end; i++) {
      ranking[i][ranking[i].keys.first]['position'] = (i + 1).toDouble();
    }
    return ranking;
  }

  /// Retrieving all user's questions
  Future<Map> getUserAnsweredQuestionsByComp() async {
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

  /// Retrieving all user's questions exp
  Future<Map> getUserExpByComp() async {
    var finalMap = {};
    var userAnsweredQuestionsByComp = await getUserAnsweredQuestionsByComp();
    for (var i = 0; i < userAnsweredQuestionsByComp.length; i++) {
      var currentComp = userAnsweredQuestionsByComp.keys.toList()[i];
      for (var j = 0;
          j < userAnsweredQuestionsByComp[currentComp].length;
          j++) {
        var currentQuestionID = userAnsweredQuestionsByComp[currentComp][j];
        var currentQData = await getCollectionDataField(
            kQuestionDBTable, 'ID', currentQuestionID.keys.toList()[0]);
        if (finalMap[currentComp] == null) {
          finalMap[currentComp] = 0;
        }
        finalMap[currentComp] = finalMap[currentComp] +
            (currentQData['difficulty'] * kDifficultyExpMultiplier);
      }
    }
    return finalMap;
  }

  /// Returns correct and incorrect answers number for all competitions
  Future<Map> getAllCompAnswerCorrectnessNum() async {
    var allUserAnsweredQuestions = await getUserAnsweredQuestions();
    //Map<String, int> finalMap = {'correct': 0, 'incorrect': 0};

    var finalMap = {};
    for (var i = 0; i < allUserAnsweredQuestions.length; i++) {
      String currentKey = allUserAnsweredQuestions.keys.toList()[i];
      bool currentValue =
          allUserAnsweredQuestions[allUserAnsweredQuestions.keys.toList()[i]];
      var currentQuestionCode =
          await getFieldData(kQuestionDBTable, currentKey, 'docCode');
      String currentQuestionCodeSanitized =
          currentQuestionCode.substring(0, currentQuestionCode.indexOf('_'));

      if (finalMap[currentQuestionCodeSanitized] == null) {
        finalMap[currentQuestionCodeSanitized] = {};
        finalMap[currentQuestionCodeSanitized]['correct'] = 0;
        finalMap[currentQuestionCodeSanitized]['incorrect'] = 0;
      }

      if (currentValue == true) {
        finalMap[currentQuestionCodeSanitized]['correct'] =
            finalMap[currentQuestionCodeSanitized]['correct'] + 1;
      } else {
        finalMap[currentQuestionCodeSanitized]['incorrect'] =
            finalMap[currentQuestionCodeSanitized]['incorrect'] + 1;
      }
    }

    return finalMap;
  }

  /// Returns correct and incorrect answers number for a given competition or in total if the argument is not passed
  Future<Map> getCompAnswerCorrectness([String? competitionCode]) async {
    var answeredQuestions =
        await getCollectionDataField('users', 'ID', auth.currentUser!.uid);
    return answeredQuestions['answeredQuestions'];
  }

  Future<Map> getTotalAnswerCorrectness() async {
    var data = await getCompAnswerCorrectness();
    num correct = 0;
    num incorrect = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[data.keys.toList()[i]]['correct'] != null) {
        correct += data[data.keys.toList()[i]]['correct'];
      }
      if (data[data.keys.toList()[i]]['incorrect'] != null) {
        incorrect += data[data.keys.toList()[i]]['incorrect'];
      }
    }
    var finalMap = {};
    finalMap['correct'] = correct;
    finalMap['incorrect'] = incorrect;
    return finalMap;
  }

  /// Returns total number of given user's exp points
  getUserTotalExp([String? userID]) async {
    String ID = userID ?? auth.currentUser!.uid;
    Map allUserAnsweredQuestions = await getUserAnsweredQuestions(ID);

    List answeredCorrectly = [];
    allUserAnsweredQuestions.forEach((key, value) {
      if (value) answeredCorrectly.add(key);
    });

    double totalExp = 0;
    for (String questionID in answeredCorrectly) {
      var currentQuestion =
          await getFieldData(kQuestionDBTable, questionID, 'difficulty');
      totalExp += kDifficultyExpMultiplier * currentQuestion;
    }

    return totalExp;
  }

  /// Returns all users IDs sorted by exp descending
  // getGlobalRanking() async {
  //   // List allUsers = await getCollectionData('users', 'ID');
  //   // Map allUsersExpMap = {};
  //   // for (var user in allUsers) {
  //   //   allUsersExpMap[user] = await getUserTotalExp(user);
  //   // }
  //   // allUsersExpMap = Map.fromEntries(allUsersExpMap.entries.toList()
  //   //   ..sort((e2, e1) => e1.value.compareTo(e2.value)));
  //   // return allUsersExpMap;
  //   var allUserExpMap = {};
  //   await firestoreInstance
  //       .collection('users')
  //       .orderBy("exp", descending: true)
  //       .get()
  //       .then((querySnapshot) {
  //     for (var result in querySnapshot.docs) {
  //       allUserExpMap[result.data()['ID']] = result.data()['exp'];
  //     }
  //   });
  // }

  /// Returns short version of global ranking - only 'adjacentNum' positions below and above given userID
  // getShortGlobalRanking([String? userID, int adjacentNum = 1]) async {
  //   // await firestoreInstance
  //   //     .collection('users')
  //   //     .orderBy("exp", descending: false)
  //   //     .get()
  //   //     .then((querySnapshot) {
  //   //   for (var result in querySnapshot.docs) {
  //   //     print(result.data());
  //   //   }
  //   // });
  //
  //   String ID = userID ?? _auth.currentUser!.uid;
  //
  //   var globalRanking = await getGlobalRanking();
  //   int userRanking = globalRanking.keys.toList().indexOf(ID);
  //   int upperLimit =
  //       userRanking - adjacentNum < 1 ? 0 : userRanking - adjacentNum;
  //   int lowerLimit = userRanking + adjacentNum >= globalRanking.length
  //       ? globalRanking.length - 1
  //       : userRanking + adjacentNum;
  //   // filling the gap
  //   if (userRanking <= adjacentNum) lowerLimit = lowerLimit + adjacentNum;
  //   //
  //   var globalRankingShort = Map.fromIterables(
  //       globalRanking.keys.skip(upperLimit).take(lowerLimit + 1),
  //       globalRanking.values.skip(upperLimit).take(lowerLimit + 1));
  //   var finalMap = {};
  //   int counter = 0;
  //   for (var key in globalRankingShort.keys.toList()) {
  //     finalMap[key] = {};
  //     finalMap[key]['exp'] = globalRankingShort[key];
  //     finalMap[key]['ranking'] = (userRanking + 1) + counter;
  //     counter++;
  //   }
  //   return finalMap;
  // }
}
