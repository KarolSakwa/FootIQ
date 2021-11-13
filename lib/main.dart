import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:provider/provider.dart';
import 'views/welcome_screen.dart';
import 'views/login_screen.dart';
import 'views/registration_screen.dart';
import 'views/quick_challenge_screen.dart';

void main() {
  Provider.debugCheckInvalidValueType =
      null; // żeby nie pojawiał się błąd  Tried to use Provider with a subtype of Listenable/Stream (AnswerSelectedNotifier).

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
