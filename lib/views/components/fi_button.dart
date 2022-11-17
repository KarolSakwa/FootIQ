import 'package:flutter/material.dart';
import 'package:footix/contants.dart';

class FIButton extends StatelessWidget {
  String text;
  var onPressed;
  Icon icon;
  MaterialStateProperty<Color>? backgroundColor;
  FIButton(
      {required this.text,
      required this.icon,
      required var this.onPressed,
      this.backgroundColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: backgroundColor ??
              MaterialStateProperty.all<Color>(kMainMediumColor),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(
                width: 10.0,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 20.0, color: kMainLightColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
