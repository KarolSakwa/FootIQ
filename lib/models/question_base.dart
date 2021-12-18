// this file is here to retrieve data from db
import 'question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionBase {
  final String _questionDBCollection = 'final_questions';

  final firestoreInstance = FirebaseFirestore.instance;

  Future<List<Map>> getQuestionList() async {
    List<Map> questionList = [];
    await firestoreInstance
        .collection(_questionDBCollection)
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        questionList.add({
          'questionText': result.data()['question_text'],
          'answerA': result.data()['answer_a'],
          'answerB': result.data()['answer_b'],
          'answerC': result.data()['answer_c'],
          'answerD': result.data()['answer_d'],
          'correctAnswer': result.data()['correct_answer'],
          'imgSrc': '', //result.data()['img_src']
          'questionCategory': '', //result.data()['question_category']
        });
        //collectionMap[result.data()['tm_code']] = result.data()['name'];
      }
      return questionList;
    });
    return questionList;
  }
}
