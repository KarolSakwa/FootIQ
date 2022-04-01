import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../../../controllers/menu_controller.dart';

class Header extends StatefulWidget {
  final Map? otherUser;
  Header({Key? key, this.otherUser}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    User? loggedInUser = _auth.currentUser;
    String? displayName = loggedInUser?.displayName;
    String? userEmail = loggedInUser?.email;
    bool isOtherUser = false;
    if (widget.otherUser != null) {
      isOtherUser = true;
      displayName = widget.otherUser!['name'];
      userEmail = widget.otherUser!['email'];
    }

    return Row(
      children: <Widget>[
        isOtherUser == false ||
                widget.otherUser!['email'] == loggedInUser?.email
            ? Material(
                type: MaterialType.transparency,
                child: Ink(
                  decoration: BoxDecoration(
                    border: Border.all(color: kMainLightColor, width: 3.0),
                    color: kMainDarkColor,
                    shape: BoxShape.rectangle,
                  ),
                  child: InkWell(
                    //This keeps the splash effect within the circle
                    borderRadius: BorderRadius.circular(1000.0),
                    onTap: () {
                      context.read<MenuController>().controlMenu;
                      //widget.scaffoldKey.currentState.openDrawer();
                      // _auth.signOut();
                      // Navigator.pushNamed(context, WelcomeScreen.id);
                    },
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
            displayName!,
            style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 20),
          ),
        )),
      ],
    );
  }
}
