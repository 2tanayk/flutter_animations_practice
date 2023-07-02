import 'package:flutter/material.dart';

//light mode colors
const kBackgroundColor = Color.fromARGB(255, 255, 255, 255);
const kPrimaryColor = Color(0xFF8B82FF);

//light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: kBackgroundColor,
  primaryColor: kPrimaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: kPrimaryColor,
    elevation: 0,
  ),
  fontFamily: 'Montserrat',
);

//dark theme
ThemeData darkTheme = ThemeData(brightness: Brightness.dark);