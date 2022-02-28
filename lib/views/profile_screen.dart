import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/components/profile_side_nav.dart';
import 'package:footix/views/login_screen.dart';
import 'package:image/image.dart';
import 'components/user_skills_radar.dart';
import 'quick_challenge_screen.dart';
import 'package:footix/models/database.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  final DB db = DB();

  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  int _myIndex = 1;
  final ItemScrollController _scrollController = ItemScrollController();
  late User loggedInUser;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String displayName = '';

  Future<List<Map>> getGlobalRank() async {
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
    return allUsersSorted;
  }

  @override
  Widget build(BuildContext context) {
    Map otherUser = ModalRoute.of(context)!.settings.arguments as Map;
    loggedInUser = _auth.currentUser;
    displayName =
        otherUser == null || otherUser['name'] == loggedInUser.displayName
            ? 'My profile'
            : otherUser['name'];
    String userEmail =
        otherUser == null || otherUser['email'] == loggedInUser.email
            ? loggedInUser.email
            : otherUser['email'];
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: ProfileSideNav(),
        body: Column(
          children: [
            Center(
                child: Column(
              children: <Widget>[
                Column(
                  children: [
                    Row(
                      children: <Widget>[
                        otherUser == null ||
                                otherUser['email'] == loggedInUser.email
                            ? Material(
                                type: MaterialType.transparency,
                                child: Ink(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kMainLightColor, width: 3.0),
                                    color: kMainDarkColor,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: InkWell(
                                    //This keeps the splash effect within the circle
                                    borderRadius: BorderRadius.circular(1000.0),
                                    onTap: () =>
                                        scaffoldKey.currentState!.openDrawer(),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.menu,
                                        size: 30.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ))
                            : IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 35,
                                  color: kMainLightColor,
                                )),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            displayName,
                            style: kWelcomeScreenTitleTextStyle.copyWith(
                                fontSize: 20),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RadarChartPage(500, 500, true)));
                    },
                    child: RadarChartPage(200, 200, false)),
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: kMainLightColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Global rank'.toUpperCase(),
                    style: TextStyle(
                        color: kMainLightColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            )),
            SizedBox(
                height: 200, // Constrain height.
                child: FutureBuilder<List>(
                  future: getGlobalRank(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ScrollablePositionedList.builder(
                            itemScrollController: _scrollController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, int position) {
                              // for calculating my index purposes
                              List<String> emailList = [];
                              snapshot.data!.forEach((element) {
                                emailList.add(element['email']);
                              });
                              _myIndex = emailList.indexOf(userEmail);
                              //
                              // _scrollController.scrollTo(
                              //     index: myIndex - 1,
                              //     duration: Duration(milliseconds: 300),
                              //     curve: Curves.ease);
                              final item = snapshot.data![position];
                              return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ProfileScreen.id, arguments: {
                                      'email': item['email'],
                                      'name': item['name']
                                    });
                                  },
                                  child: Card(
                                    child: ListTile(
                                      tileColor: position == _myIndex
                                          ? kMainMediumColor
                                          : kMainGreyColor,
                                      title: Text(
                                        '${position + 1}. ${item['name']} - ${getMapSum(item['exp'])}',
                                        style: TextStyle(
                                            color: kMainLightColor,
                                            fontWeight: position == _myIndex
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      ),
                                    ),
                                  ));
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                )),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        bottomNavigationBar:
            otherUser == null || otherUser['email'] == loggedInUser.email
                ? Material(
                    color: Colors.greenAccent,
                    child: InkWell(
                      onTap: () {
                        //print('called on tap');
                      },
                      child: SizedBox(
                        height: kToolbarHeight,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'New challenge'.toUpperCase(),
                            style: TextStyle(
                              color: kMainDarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Text('data'),
      ),
    );
  }

  double getMapSum(Map map) {
    double totalSum = 0;
    for (var i = 0; i < map.keys.toList().length; i++) {
      totalSum += map[map.keys.toList()[i]];
    }
    return totalSum;
  }
}
