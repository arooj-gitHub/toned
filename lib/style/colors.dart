import 'package:flutter/material.dart';

const primaryColor = Color(0xFFB29965);
const secondaryColor = Color(0xFFC9CADD);

//default
const Color successColor = Color(0xff2CAE60);
const Color errorColor = Color(0xFFEB5757);

//Light mode
//background
const bgLightColor = Color(0xFFFFFFFF);
//button
const Color buttonLightColor = Color(0xFF000000);
const Color textLightColor = Color(0xFFFFFFFF);

//Dark mode
//background
const bgDarkColor = Color(0xFF000000);

//button
const Color buttonDarkColor = Color(0xFFFFFFFF);
const Color textDarkColor = Color(0xFF000000);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  primaryColor: primaryColor,
  // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
  //     .apply(bodyColor: Colors.black),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.black),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),
  ),
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(color: Colors.black),
    color: Colors.transparent,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: secondaryColor,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: primaryColor,
  ),
  colorScheme: ColorScheme.fromSwatch(
      primarySwatch: const MaterialColor(0xFFE5CA71, {
    50: primaryColor,
    100: primaryColor,
    200: primaryColor,
    300: primaryColor,
    400: primaryColor,
    500: primaryColor,
    600: primaryColor,
    700: primaryColor,
    800: primaryColor,
    900: primaryColor,
  })).copyWith(background: bgLightColor).copyWith(error: errorColor),
);

const greenColor = Color(0xff0DAE91);
