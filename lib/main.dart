import 'package:flutter/material.dart';

import 'package:coin_sage/screens/home_page.dart';
import 'package:coin_sage/assets/defaults.dart';

final customisedTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: blue,
    // primary: Color.fromARGB(255, 12, 6, 41),
    // onPrimary: Color.fromARGB(255, 215, 208, 208),
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: customisedTheme,
      home: HomePage(),
    );
  }
}
