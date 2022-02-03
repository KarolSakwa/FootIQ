import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/components/profile_side_nav.dart';
import 'quick_challenge_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: ProfileSideNav(),
        body: Stack(
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
                                    color: kMainLightColor, width: 3.0),
                                color: kMainDarkColor,
                                shape: BoxShape.rectangle,
                              ),
                              child: InkWell(
                                //This keeps the splash effect within the circle
                                borderRadius: BorderRadius.circular(
                                    1000.0), //Something large to ensure a circle
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
                            )),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            _auth.currentUser.displayName,
                            style: kWelcomeScreenTitleTextStyle.copyWith(
                                fontSize: 20),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kMainMediumColor),
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
                          style:
                              TextStyle(fontSize: 20.0, color: kMainLightColor),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, QuickChallengeScreen.id);
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
/*
IntrinsicHeight(
              child: Stack(
                children: [
                  Align(
                      child: Text(
                    _auth.currentUser.email,
                    style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 30),
                  )),
                  Positioned(
                    left: 0,
                    child: Material(
                        type: MaterialType
                            .transparency, //Makes it usable on any background color, thanks @IanSmith
                        child: Ink(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: kMainLightColor, width: 3.0),
                            color: kMainDarkColor,
                            shape: BoxShape.rectangle,
                          ),
                          child: InkWell(
                            //This keeps the splash effect within the circle
                            borderRadius: BorderRadius.circular(
                                1000.0), //Something large to ensure a circle
                            onTap: () => scaffoldKey.currentState!.openDrawer(),
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
                  ),
                ],
              ),
            )
 */
