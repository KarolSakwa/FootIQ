import 'package:flutter/material.dart';

const kAppName = 'FootIQ';

// color palette
const kMainDarkColor = Color(0xff0b1724);
const kMainCardColor = Color(0xff10263d);
const kMainLightColor = Color(0xffd4ecdd);
const kMainMediumColor = Color(0xff7facb4);
const kMainGreyColor = Color(0xff717575);
const kMainRed = Color(0xff892971);
const kMainDefaultPadding = 16.0;
const kMainCardPadding = 8.0;

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

ButtonStyle kAnswerInitialButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(kMainLightColor),
  backgroundColor: MaterialStateProperty.all<Color>(kMainMediumColor),
);

ButtonStyle kAnswerSelectedButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(kMainLightColor),
  backgroundColor: MaterialStateProperty.all<Color>(kMainGreyColor),
);

ButtonStyle kAnswerSelectedIncorrectButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(kMainLightColor),
  backgroundColor: MaterialStateProperty.all<Color>(const Color(0x52120DFF)),
);

ButtonStyle kAnswerSelectedCorrectButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(kMainLightColor),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
);

double kDifficultyExpMultiplier = 2;
String kNoAnsweredQuestions = 'No answered questions!';
String kQuestionDBTable = 'new_final_questions';
String kTooLittleData =
    'Too little data! Complete your first challenge to access your stats!';
