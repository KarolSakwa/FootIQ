import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/components/profile_side_nav.dart';
import 'package:footix/views/dashboard/global_ranking_screen.dart';
import 'answer_correctness_screen.dart';
import 'components/user_skills_radar.dart';
import 'components/dashboard_card.dart';
import 'components/footer.dart';
import 'components/global_ranking.dart';
import 'package:footix/models/database.dart';
import 'components/user_answer_correctneess_pie_chart.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  final DB db = DB();
  final _auth = FirebaseAuth.instance;

  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    User? loggedInUser = _auth.currentUser;
    Map otherUser = ModalRoute.of(context)!.settings.arguments
        as Map; // comes from argument of previous screen
    return FutureBuilder(
      future: widget.db.getAnswerCorrectnessMap(loggedInUser?.uid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          int correctAnswers = snapshot.data['answeredCorrectlyTotal'].toInt();
          int incorrectAnswers = (snapshot.data['askedTimesTotal'] -
                  snapshot.data['answeredCorrectlyTotal'])
              .toInt();
          return SafeArea(
            child: Scaffold(
                drawer: ProfileSideNav(),
                appBar: AppBar(
                  backgroundColor: kMainDarkColor,
                  foregroundColor: kMainLightColor,
                  elevation: 0,
                  title: Text(loggedInUser?.displayName ?? 'Profile'),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(kMainDefaultPadding),
                  child: Column(
                    children: [
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserSkillsRadar(500, 500, true)));
                          },
                          child: DashboardCard(
                              child: UserSkillsRadar(250, 250, false))),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GlobalRankingScreen()));
                          },
                          child: DashboardCard(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Global ranking'.toUpperCase(),
                                    style: const TextStyle(
                                        color: kMainLightColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  height: 200, // Constrain height.
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(kMainCardPadding),
                                    child: GlobalRanking(),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AnswerCorrectnessScreen.id,
                                arguments: {
                                  'correctAnswers': correctAnswers,
                                  'incorrectAnswers': incorrectAnswers
                                });
                          },
                          child: DashboardCard(
                              child: Padding(
                            padding: const EdgeInsets.all(kMainCardPadding),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      'Answer correctness'.toUpperCase(),
                                      style: const TextStyle(
                                          color: kMainLightColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  UserAnswerCorrectnessPieChart(
                                      correctAnswers: correctAnswers,
                                      incorrectAnswers: incorrectAnswers)
                                ],
                              ),
                            ),
                          ))),
                    ],
                  ),
                ),
                bottomNavigationBar: Footer(otherUser: otherUser)),
          );
        } else {
          return const SizedBox(
              width: 200, height: 200, child: CircularProgressIndicator());
        }
      },
    );
  }
}

double getMapSum(Map map) {
  double totalSum = 0;
  for (var i = 0; i < map.keys.toList().length; i++) {
    totalSum += map[map.keys.toList()[i]];
  }
  return totalSum;
}
