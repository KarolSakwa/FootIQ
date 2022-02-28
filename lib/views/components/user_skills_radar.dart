import 'package:footix/contants.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:flutter/material.dart';
import 'package:footix/models/database.dart';

class RadarChartPage extends StatefulWidget {
  double? width, height;
  bool fullScreen = false;

  RadarChartPage(this.width, this.height, this.fullScreen, {Key? key})
      : super(key: key);

  @override
  State<RadarChartPage> createState() => _RadarChartPageState();
}

class _RadarChartPageState extends State<RadarChartPage> {
  final DB db = DB();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([db.getCollectionData('competition')]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError)
            return Container(
                width: widget.width,
                height: widget.height,
                child: Text("Error Occurred"));
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
    List competitionMap = snapshot.data[0];
    List<String> competitionList = [];
    for (var i = 0; i < competitionMap.length; i++) {
      competitionList.add(competitionMap[i]['name']);
    }
    const ticks = [7, 14, 21, 28, 35];
    //var features = ["AA", "BB", "CC", "DD", "EE", "FF", "GG", "HH"];
    var data = [
      [10, 20, 28, 5, 16, 15, 17, 6]
    ];
    //features = features.sublist(0, features.length);
    //data = data.map((graph) => graph.sublist(0, features.length)).toList();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: RadarChart.dark(
                ticks: ticks,
                features: competitionList,
                data: data,
                reverseAxis: true,
                useSides: true,
              )),
            ],
          )),
    );
  }
}
