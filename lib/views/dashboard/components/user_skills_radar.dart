import 'package:firebase_auth/firebase_auth.dart';
import 'package:footix/contants.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:flutter/material.dart';
import 'package:footix/models/database.dart';
import 'package:footix/views/components/question_card.dart';

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
          db.getCollectionDataField(
              'users', 'ID', widget._auth.currentUser!.uid)
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
    var competitionsMaximumExp = [];
    compMaxExpMapDebug2.forEach((element) {
      competitionsMaximumExp.add(element['exp']);
    });

    List<int> competitionsMaximumExpList = [];
    for (var i = 0; i < competitionsMaximumExp.length; i++) {
      competitionsMaximumExpList
          .add((competitionsMaximumExp[i].toInt()).toInt());
    }

    List<int> ticks = getTicksList(competitionsMaximumExpList, 3);
    Map dataMap = getLoggedInUserExpMap(snapshot.data[0]);
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
                  data: [dataMap['exps']],
                  reverseAxis: false,
                  useSides: true,
                )),
              ],
            )),
      ),
    );
  }

  getLoggedInUserExpMap(expMap) {
    var compCode = expMap['exp'];
    List<String> namesList = [];
    List<num> expsList = [];
    for (var i = 0; i < compCode.keys.length; i++) {
      var current = compMaxExpMapDebug2
          .where((m) => m['code'].startsWith(compCode.keys.toList()[i]));
      namesList.add(current.toList()[0]['name']);
      expsList.add(compCode[current.toList()[0]['code']]);
    }
    var finalMap = {};
    finalMap['names'] = namesList;
    finalMap['exps'] = expsList;
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
