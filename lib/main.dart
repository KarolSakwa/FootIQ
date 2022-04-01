import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/admin_screen.dart';
import 'package:footix/views/main_screen.dart';
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
          ScoreScreen.id: (context) => ScoreScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          //DashboardScreen.id: (context) => DashboardScreen(),
          AdminScreen.id: (context) => AdminScreen(),
        },
        title: kAppName,
        navigatorKey: navigatorKey,
      ),
    );
  }
}
/*
return FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
                       if (snapshot.hasData){
                           FirebaseUser user = snapshot.data; // this is your user instance
                           /// is because there is user already logged
                           return MainScreen();
                        }
                         /// other way there is no user logged.
                         return LoginScreen();
             }
          );
 */
