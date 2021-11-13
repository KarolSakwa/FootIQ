import 'dart:async';
import 'package:flutter/material.dart';

class DisappearingAlertDialog {
  late int milliseconds;
  AlertDialog alertDialog = AlertDialog();
  late BuildContext context;

  DisappearingAlertDialog(
      {milliseconds = 2000, required alertDialog, required context}) {
    this.milliseconds = milliseconds;
    this.alertDialog = alertDialog;
    this.context = context;

    Timer? timer = Timer(Duration(milliseconds: milliseconds), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        }).then((value) {
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });
  }
}
