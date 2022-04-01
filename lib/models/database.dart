import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/models/question.dart';
import 'package:footix/views/components/question_card.dart';
import 'package:uuid/uuid.dart';
import 'package:footix/contants.dart';

class DB {
  final firestoreInstance = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<dynamic> getCollectionData(String collection) async {
    List<Map> fieldList = [];
    await firestoreInstance.collection(collection).get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        fieldList.add(result.data());
      }
    });
    return fieldList;
  }

  Future<dynamic> getCollectionDataField(
      String collection, String field, String fieldValue) async {
    var collectionDataField;
    await firestoreInstance
        .collection(collection)
        .where(field, isEqualTo: fieldValue)
        .get()
        .then((value) {
      collectionDataField = value.docs[0].data();
    });
    return collectionDataField;
  }

  Future<dynamic> getFieldData(
      String collection, String documentID, String fieldName) async {
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
  void addData(String collection, Map<String, dynamic> data, {String? id}) {
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
    //
  }

  void addAnsweredQuestion(Question question) {}

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

  Future<double> getTotalCompetitionExp(
      {required String competitionCode}) async {
    double result = 0;
    await firestoreInstance
        .collection('new_final_questions')
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

  // Future<dynamic> getLoggedInUserExpMap() async {
  //   var allComp = await getCollectionData('competition');
  //   var expMap = {};
  //   for (var i = 0; i < allComp.length; i++) {
  //     var compExp = await getCollectionDataField(
  //         'users', 'email', _auth.currentUser?.email ?? '');
  //     print(compExp);
  //   }
  // }
}
