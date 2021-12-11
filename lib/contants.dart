import 'package:flutter/material.dart';

const kAppName = 'FootiX9';

// color palette
const kMainDarkColor = Color(0xff0b1724);
const kMainLightColor = Color(0xffd4ecdd);
const kMainMediumColor = Color(0xff7facb4);
const kMainGreyColor = Color(0xff717575);

const kWelcomeScreenTitleTextStyle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 90.0,
    fontWeight: FontWeight.bold,
    color: kMainLightColor);
const kWelcomeScreenTitleText = Text(
  kAppName,
  style: kWelcomeScreenTitleTextStyle,
);
const kQuestionTextStyle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: kMainDarkColor);

var kAnswerButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(kMainMediumColor),
);
