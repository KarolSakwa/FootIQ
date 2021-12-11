import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/admin_screen.dart';
import 'package:provider/provider.dart';
import 'views/welcome_screen.dart';
import 'views/login_screen.dart';
import 'views/registration_screen.dart';
import 'views/quick_challenge_screen.dart';
import 'views/score_screen.dart';
import 'package:footix/views/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType =
      null; // żeby nie pojawiał się błąd  Tried to use Provider with a subtype of Listenable/Stream (AnswerSelectedNotifier).

  runApp(FootiX9());
}

class FootiX9 extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
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
        ScoreScreen.id: (context) => ScoreScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        AdminScreen.id: (context) => AdminScreen(),
      },
      title: kAppName,
      navigatorKey: navigatorKey,
    );
  }
}
