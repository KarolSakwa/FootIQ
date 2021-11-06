import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/quick_challenge_screen.dart';

void main() {
  runApp(FootiX9());
}

class FootiX9 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: kMainDarkColor,
        backgroundColor: kMainDarkColor,
        primaryColor: kMainMediumColor,
        primaryColorLight: kMainLightColor,
        primaryColorDark: kMainDarkColor,
        fontFamily: 'Lato',
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        QuickChallengeScreen.id: (context) => QuickChallengeScreen(),
      },
      title: kAppName,
    );
  }
}
