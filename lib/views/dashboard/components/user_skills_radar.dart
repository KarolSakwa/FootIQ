import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/contants.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:flutter/material.dart';
import 'package:footix/controllers/api_controller.dart';
import 'package:footix/models/firebase_service.dart';
import 'package:footix/repository/answered_questions_repository.dart';

class UserSkillsRadar extends StatefulWidget {
  double? width, height;
  bool fullScreen = false;
  final _auth = FirebaseAuth.instance;

  UserSkillsRadar(this.width, this.height, this.fullScreen, {Key? key})
      : super(key: key);

  @override
  State<UserSkillsRadar> createState() => _UserSkillsRadarState();
}

class _UserSkillsRadarState extends State<UserSkillsRadar> {
  final AnsweredQuestionsRepository answeredQuestionsRepository =
      AnsweredQuestionsRepository();
  APIController apiController = APIController();

  @override
  Widget build(BuildContext context) {
    var userEmail = widget._auth.currentUser?.email;
    return FutureBuilder<List>(
        future: Future.wait([
          answeredQuestionsRepository
              .getUserGainedExpCompetitionMap(widget._auth.currentUser!.uid),
          apiController.getCompetitionNames()
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return SizedBox(
                width: widget.width,
                height: widget.height,
                child: const Text("Error Occurred"));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: Center(child: const CircularProgressIndicator()));
            case ConnectionState.done:
              return Center(
                  child: widget.fullScreen
                      ? Scaffold(
                          body: mainContent(snapshot),
                          appBar: AppBar(
                            title: const Text("Profile"),
                            backgroundColor: kMainDarkColor,
                          ),
                        )
                      : mainContent(snapshot));
            default:
              return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget mainContent(snapshot) {
    var sortedKeys = snapshot.data[0].keys.toList()..sort();
    var transformedMap = {
      for (var key in sortedKeys) key: snapshot.data[0][key]
    };
    List<List<num>> competitionsExps = [
      transformedMap.values.toList().cast<num>()
    ];
    var radarTicks = [250, 500, 750, 1000];

    return SafeArea(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kMainDefaultPadding),
                  child: Text(
                    'Your knowledge'.toUpperCase(),
                    style: const TextStyle(
                        color: kMainLightColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                    child: RadarChart.dark(
                  ticks: radarTicks,
                  features: snapshot.data[1],
                  data: competitionsExps,
                  reverseAxis: false,
                  useSides: true,
                )),
              ],
            )),
      ),
    );
  }

  // generateRadarTicks(data) {
  //   var ticks = data.values.toList();
  //   ticks.sort();
  //   int maxValue =
  //       (ticks.reduce((value, element) => value > element ? value : element) *
  //           40);
  //   int step = (maxValue / 4).round();
  //   List<int> radarTicks = List.generate(5, (index) => index * step);
  //   radarTicks.removeAt(0);
  //
  //   return radarTicks;
  // }
}
