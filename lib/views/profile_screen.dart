import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/components/profile_side_nav.dart';
import 'package:image/image.dart';
import 'components/user_skills_radar.dart';
import 'quick_challenge_screen.dart';
import 'package:footix/models/database.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  final DB db = DB();

  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String displayName = '';

  Future<int> getUserRank(String email) async {
    List<Map> allUsersSorted = await widget.db.getCollectionData("users");
    allUsersSorted.sort((m1, m2) {
      double totalM1 = 0;
      for (var i = 0; i < m1['exp'].keys.toList().length; i++) {
        totalM1 += m1['exp'].values.toList()[i];
      }
      double totalM2 = 0;
      for (var i = 0; i < m2['exp'].keys.toList().length; i++) {
        totalM2 += m2['exp'].values.toList()[i];
      }
      var r = totalM2.compareTo(totalM1);
      if (r != 0) return r;
      return totalM1.compareTo(totalM2);
    });
    return (allUsersSorted
            .indexOf(allUsersSorted.where((c) => c['email'] == email).first)) +
        1;
  }

  @override
  void initState() {
    super.initState();
    loggedInUser = _auth.currentUser;
    displayName = loggedInUser.displayName;
    //
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          drawer: ProfileSideNav(),
          body: FutureBuilder(
            future: Future.wait([getUserRank(loggedInUser.email)]), // zmienić!
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Center(
                          child: Column(
                        children: <Widget>[
                          Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Material(
                                      type: MaterialType
                                          .transparency, //Makes it usable on any background color, thanks @IanSmith
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: kMainLightColor,
                                              width: 3.0),
                                          color: kMainDarkColor,
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: InkWell(
                                          //This keeps the splash effect within the circle
                                          borderRadius: BorderRadius.circular(
                                              1000.0), //Something large to ensure a circle
                                          onTap: () => scaffoldKey.currentState!
                                              .openDrawer(),
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.menu,
                                              size: 30.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text(
                                      displayName,
                                      style: kWelcomeScreenTitleTextStyle
                                          .copyWith(fontSize: 20),
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            'Global rank: ${snapshot.data[0]}',
                            style: TextStyle(
                                color: kMainLightColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const RadarChartPage(),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(kMainMediumColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 60),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    color: kMainLightColor,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'Start Challenge',
                                    style: TextStyle(
                                        fontSize: 20.0, color: kMainLightColor),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, QuickChallengeScreen.id);
                            },
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }
}
