import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:footix/views/components/question_card.dart';
import 'package:uuid/uuid.dart';

class DB {
  final firestoreInstance = FirebaseFirestore.instance;

  Future<dynamic> getCollectionData(String collection) async {
    List<Map> fieldList = [];
    await firestoreInstance.collection(collection).get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        fieldList.add(result.data());
      }
    });
    return fieldList;
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

  void incrementUserCompExp(String userID, String compName, double value) {
    firestoreInstance
        .collection('users')
        .doc(userID)
        .update({'exp.$compName': FieldValue.increment(value)});
  }
}
