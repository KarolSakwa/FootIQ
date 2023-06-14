import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:footix/views/add_question_screen.dart';
import 'package:footix/views/login_screen.dart';
import 'package:footix/views/admin_screen.dart';
import 'package:footix/views/registration_screen.dart';
import 'components/fi_button.dart';
import 'quick_challenge_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 70.0),
          child: Column(
            children: [
              const Center(
                child: kWelcomeScreenTitleText,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
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
                          children: const [
                            Icon(
                              Icons.local_fire_department,
                              color: kMainLightColor,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Quick challenge',
                              style: TextStyle(
                                  fontSize: 20.0, color: kMainLightColor),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, QuickChallengeScreen.id);
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
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
                          children: const [
                            Icon(
                              Icons.plus_one,
                              color: kMainLightColor,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Add question',
                              style: TextStyle(
                                  fontSize: 20.0, color: kMainLightColor),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AddQuestionScreen.id);
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: FIButton(
                      text: 'Login',
                      icon: Icon(
                        Icons.person,
                        color: kMainLightColor,
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(kMainGreyColor),
                      onPressed: () =>
                          Navigator.pushNamed(context, LoginScreen.id),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, RegistrationScreen.id),
                child: const Text(
                  "Don't have an account? Register here!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // Center(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 20.0),
              //     child: TextButton(
              //       style: ButtonStyle(
              //         backgroundColor:
              //             MaterialStateProperty.all<Color>(kMainGreyColor),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(
              //             vertical: 18.0, horizontal: 105.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Icon(
              //               Icons.person,
              //               color: kMainLightColor,
              //             ),
              //             SizedBox(
              //               width: 10.0,
              //             ),
              //             Text(
              //               'SAP',
              //               style: TextStyle(
              //                   fontSize: 20.0, color: kMainLightColor),
              //             ),
              //           ],
              //         ),
              //       ),
              //       onPressed: () {
              //         Navigator.pushNamed(context, AdminScreen.id);
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
