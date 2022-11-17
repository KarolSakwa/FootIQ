import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';

import 'components/fi_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const String id = 'forgot_password_screen';

  @override
  Widget build(BuildContext context) {
    String email = '';
    return Scaffold(
      backgroundColor: kMainDarkColor,
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: kMainDarkColor,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
        //padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: kMainDefaultPadding),
              child: Text(
                'Please enter your e-mail address so that we can send you a password',
                style: kWelcomeScreenTitleTextStyle.copyWith(fontSize: 18),
              ),
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.done,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email!'
                      : null,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: BorderSide(color: kMainLightColor, width: 1),
                  ),
                  hintStyle: TextStyle(color: kMainLightColor),
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: kMainLightColor),
                  hintText: 'Enter your e-mail address'),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            FIButton(
              text: 'Reset password',
              icon: const Icon(
                Icons.email,
                color: kMainLightColor,
              ),
              onPressed: resetPassword(email),
            )
          ],
        ),
      ),
    );
  }
}

resetPassword(email) {
  FirebaseAuth.instance
      .sendPasswordResetEmail(email: email)
      .whenComplete(() => print('dsa'));
}

class EmailValidator {
  static bool validate(email) {
    if (!email.contains('@')) {
      return false;
    }
    return true;
  }
}
