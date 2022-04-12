import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/contants.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:flutter/material.dart';
import 'package:footix/models/database.dart';
import 'dart:math';

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
  final DB db = DB();

  @override
  Widget build(BuildContext context) {
    var userEmail = widget._auth.currentUser?.email;
    return FutureBuilder(
        future: Future.wait([
          db.getMaximumExpCompetitionsMap(),
          db.getCollectionData('competition'),
          db.getCollectionDataField('users', 'email', userEmail!)
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Container(
                width: widget.width,
                height: widget.height,
                child: const Text("Error Occurred"));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  width: widget.width,
                  height: widget.height,
                  child: Center(child: CircularProgressIndicator()));
            case ConnectionState.done:
              return Center(
                  child: widget.fullScreen
                      ? Scaffold(body: mainContent(snapshot))
                      : mainContent(snapshot));
            default:
              return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget mainContent(snapshot) {
    var competitionsMaximumExp = snapshot.data[0].values.toList();
    List<int> competitionsMaximumExpList = [];
    for (var i = 0; i < competitionsMaximumExp.length; i++) {
      competitionsMaximumExpList
          .add((competitionsMaximumExp[i].toInt() / 3).toInt());
    }

    List<int> ticks = getTicksList(competitionsMaximumExpList, 3);
    Map dataMap = getLoggedInUserExpMap(
        snapshot.data[1], snapshot.data[2], snapshot.data[0]);
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
                  ticks: ticks,
                  features: dataMap['names'],
                  data: [dataMap['userExp']],
                  reverseAxis: false,
                  useSides: true,
                )),
              ],
            )),
      ),
    );
  }

  getLoggedInUserExpMap(competitions, userData, expList) {
    var competitionMap = {};
    for (var i = 0; i < competitions.length; i++) {
      competitionMap[competitions[i]['tm_code']] = {
        'name': competitions[i]['name'],
        'userExp': userData['exp'][competitions[i]['tm_code']] ?? 0,
        'maxExp': expList[competitions[i]['tm_code']]
      };
    }
    List<String> competitionsNames = [];
    List<double> competitionsUserExp = [];
    List<double> competitionsMaxExp = [];
    for (var i = 0; i < competitionMap.length; i++) {
      competitionsNames.add(competitionMap[competitions[i]['tm_code']]['name']);
      print(competitionMap[competitions[i]['tm_code']]['userExp']);
      competitionsUserExp.add(
          competitionMap[competitions[i]['tm_code']]['userExp'].toDouble());
      competitionsMaxExp
          .add(competitionMap[competitions[i]['tm_code']]['maxExp'].toDouble());
    }
    Map finalMap = {
      'raw': competitionMap,
      'names': competitionsNames,
      'userExp': competitionsUserExp,
      'maxExp': competitionsMaxExp
    };
    return finalMap;
  }

  List<int> getTicksList(competitionMaxExpList, numOfTicks) {
    List<int> ticksList = [];
    competitionMaxExpList.sort();
    int highestNum = competitionMaxExpList.last;
    for (var i = 1; i < numOfTicks + 1; i++) {
      int currentNum = (highestNum / i).round();
      ticksList.add(currentNum);
    }
    ticksList.sort();
    return ticksList;
  }
}
