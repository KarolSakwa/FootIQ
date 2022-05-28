// this file is here to retrieve data from db
import '../contants.dart';
import 'question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionBase {
  final String _questionDBCollection = kQuestionDBTable;

  final firestoreInstance = FirebaseFirestore.instance;

  Future<List<Map>> getQuestionList() async {
    List<Map> questionList = [];
    await firestoreInstance
        .collection(_questionDBCollection)
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        questionList.add({
          'ID': result.data()['ID'],
          'questionText': result.data()['question_text'],
          'answerA': result.data()['answer_a'],
          'answerB': result.data()['answer_b'],
          'answerC': result.data()['answer_c'],
          'answerD': result.data()['answer_d'],
          'correctAnswer': result.data()['correct_answer'],
          'imgSrc': '', //result.data()['img_src']
          'questionCode': result.data()['docCode'],
          'questionCategory': '', //result.data()['question_category']
        });
      }
      return questionList;
    });
    return questionList;
  }
}
