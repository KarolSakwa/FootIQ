import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import '../models/competition.dart';
import 'package:footix/controllers/api_controller.dart';

class AddQuestionScreen extends StatefulWidget {
  static const String id = 'add_question_screen';

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  String questionText = '';
  String answerA = '';
  String answerB = '';
  String answerC = '';
  String answerD = '';
  String correctAnswer = '';
  Competition? selectedCompetition;
  int season = 0;
  final APIController apiController = APIController();
  List<Competition> competitionOptions = [];
  bool isSeasonValid = true;
  bool areAnswersValid = true;

  @override
  void initState() {
    super.initState();
    fetchCompetitionOptions();
  }

  void fetchCompetitionOptions() async {
    List<dynamic> competitionData = await apiController.getCompetitions();
    List<Competition> competitions = [];

    for (var data in competitionData) {
      Competition competition = Competition(
        id: data.id,
        name: data.name,
        code: data.code,
        logoPath: data.logoPath,
        reputation: data.reputation,
      );
      competitions.add(competition);
    }

    setState(() {
      competitionOptions = competitions;
    });
  }

  validate() async {
    isSeasonValid = season.toString().length == 4;
    areAnswersValid =
        [answerA, answerB, answerC, answerD].contains(correctAnswer) &&
            correctAnswer != '';

    setState(() {
      isSeasonValid = isSeasonValid;
      areAnswersValid = areAnswersValid;
    });

    return areAnswersValid && isSeasonValid;
  }

  addQuestionToQueue(BuildContext context) async {
    var isValid = await validate();
    if (isValid) {
      await apiController.sendFormData(questionText, season, answerA, answerB,
          answerC, answerD, correctAnswer, selectedCompetition!.id);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.greenAccent, // Tło zielone
            title: Row(
              children: [
                Icon(Icons.check_circle,
                    color: Colors.black), // Ikona potwierdzenia
                SizedBox(width: 8),
                Text(
                  'Success',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            content: const Text(
              'Your question has been added to the queue!',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainDarkColor,
      appBar: AppBar(
        title: const Text("Add Question"),
        backgroundColor: Color(0xFF0B1724FF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'Question Text',
                  labelStyle: TextStyle(color: kMainLightColor),
                ),
                onChanged: (value) {
                  setState(() {
                    questionText = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'Answer A',
                  labelStyle: TextStyle(color: kMainLightColor),
                ),
                onChanged: (value) {
                  setState(() {
                    answerA = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'Answer B',
                  labelStyle: TextStyle(color: kMainLightColor),
                ),
                onChanged: (value) {
                  setState(() {
                    answerB = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'Answer C',
                  labelStyle: TextStyle(color: kMainLightColor),
                ),
                onChanged: (value) {
                  setState(() {
                    answerC = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'Answer D',
                  labelStyle: TextStyle(color: kMainLightColor),
                ),
                onChanged: (value) {
                  setState(() {
                    answerD = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'Correct Answer',
                  labelStyle: TextStyle(color: kMainLightColor),
                  errorText: areAnswersValid
                      ? null
                      : 'One of the answers (A, B, C or D) has to be the same as this one!',
                ),
                onChanged: (value) {
                  setState(() {
                    correctAnswer = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<Competition>(
                  value: selectedCompetition,
                  onChanged: (Competition? value) {
                    setState(() {
                      selectedCompetition = value;
                    });
                  },
                  items: competitionOptions.map((Competition competition) {
                    return DropdownMenuItem<Competition>(
                      value: competition,
                      child: Text(
                        competition.name,
                        style: TextStyle(
                          color: selectedCompetition == competition
                              ? kMainLightColor
                              : kMainDarkColor, // Cambia el color del texto aquí
                        ),
                      ),
                    );
                  }).toList(),
                  dropdownColor:
                      kMainMediumColor, // Cambia el color de fondo del dropdown aquí
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kMainLightColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kMainLightBlue, width: 1),
                    ),
                    labelText: 'Competition',
                    labelStyle: TextStyle(color: kMainLightColor),
                    hintStyle: TextStyle(color: kMainLightColor),
                  ),
                  style: TextStyle(
                      color:
                          kMainDarkColor), // Cambia el color del texto seleccionado aquí
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: TextStyle(color: kMainLightColor),
                cursorColor: kMainLightColor,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'Season',
                  labelStyle: TextStyle(color: kMainLightColor),
                  errorText: isSeasonValid ? null : 'The season is incorrect',
                ),
                onChanged: (value) {
                  setState(() {
                    season = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  kMainMediumColor,
                ),
              ),
              onPressed: () => addQuestionToQueue(context),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 105),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 20, color: kMainLightColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
