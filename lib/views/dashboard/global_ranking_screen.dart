import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/dashboard/components/global_ranking.dart';

class GlobalRankingScreen extends StatefulWidget {
  const GlobalRankingScreen({Key? key}) : super(key: key);

  @override
  _GlobalRankingScreenState createState() => _GlobalRankingScreenState();
}

class _GlobalRankingScreenState extends State<GlobalRankingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            backgroundColor: kMainDarkColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(kMainDefaultPadding),
                  child: Text(
                    'Global ranking'.toUpperCase(),
                    style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 25),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 500,
                    child: GlobalRanking(),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
