import 'package:flutter/material.dart';

import 'animation_examples/collapsing_appbar_pfp.dart';
import 'themes/theme_constants.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qzend',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}