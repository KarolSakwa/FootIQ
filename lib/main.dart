import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/admin_screen.dart';
import 'package:footix/views/dashboard/answer_correctness_screen.dart';
import 'package:footix/views/main_screen.dart';
import 'package:provider/provider.dart';
import 'views/welcome_screen.dart';
import 'views/login_screen.dart';
import 'views/registration_screen.dart';
import 'views/quick_challenge_screen.dart';
import 'views/score_screen.dart';
import 'package:footix/views/dashboard/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType =
      null; // to avoid error: Tried to use Provider with a subtype of Listenable/Stream (AnswerSelectedNotifier).

  runApp(FootiIQ());
}

class FootiIQ extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const FootiIQ({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        MainScreen();
      },
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: kMainDarkColor,
          backgroundColor: kMainDarkColor,
          primaryColor: kMainMediumColor,
          primaryColorLight: kMainLightColor,
          primaryColorDark: kMainDarkColor,
          fontFamily: 'Lato',
        ),
        initialRoute: MainScreen.id,
        routes: {
          MainScreen.id: (context) => MainScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          QuickChallengeScreen.id: (context) => QuickChallengeScreen(),
          ScoreScreen.id: (context) => ScoreScreen(''),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          //DashboardScreen.id: (context) => DashboardScreen(),
          AdminScreen.id: (context) => AdminScreen(),
          AnswerCorrectnessScreen.id: (context) => AnswerCorrectnessScreen(),
        },
        title: kAppName,
        navigatorKey: navigatorKey,
      ),
    );
  }
}
