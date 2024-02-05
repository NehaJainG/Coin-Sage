import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:coin_sage/firebase_options.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/screens/app_gate.dart';

final customisedTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: herodarkBlue,
  ),

  //textTheme: GoogleFonts.poppinsTextTheme(),
);
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: herodarkBlue,
  ),

  //textTheme: GoogleFonts.poppinsTextTheme(),
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your CoinSage',
      theme: customisedTheme,
      darkTheme: darkTheme,
      home: AppGate(),
      debugShowCheckedModeBanner: false,
      // ,
    );
  }
}
