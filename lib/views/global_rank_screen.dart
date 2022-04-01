import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/dashboard/components/global_rank.dart';

class GlobalRankScreen extends StatefulWidget {
  const GlobalRankScreen({Key? key}) : super(key: key);

  @override
  _GlobalRankScreenState createState() => _GlobalRankScreenState();
}

class _GlobalRankScreenState extends State<GlobalRankScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(kMainDefaultPadding),
              child: Text(
                'Global rank'.toUpperCase(),
                style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 25),
              ),
            ),
            Flexible(
              child: Container(
                height: 1000,
                child: GlobalRank(
                  adjacentElemNum: -1,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
