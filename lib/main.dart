import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:coin_sage/firebase_options.dart';

import 'package:coin_sage/defaults/colors.dart';

import 'package:coin_sage/presentation/app_gate.dart';
import 'package:coin_sage/presentation/onboarding/onboarding.dart';

import 'package:coin_sage/services/push_notification.dart';

final customisedTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: heroBlue,
  ),

  //textTheme: GoogleFonts.poppinsTextTheme(),
);
// final darkTheme = ThemeData(
//   useMaterial3: true,
//   colorScheme: ColorScheme.fromSeed(
//     brightness: Brightness.dark,
//     seedColor: heroBlue,
//   ),

//   //textTheme: GoogleFonts.poppinsTextTheme(),
// );

bool? seenOnboard;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  seenOnboard = prefs.getBool('seenOnboard') ?? false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  PushNotifications.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Sage',
      theme: customisedTheme,
      home: seenOnboard == true ? const AppGate() : const OnBoardingScreen(),
      debugShowCheckedModeBanner: false,
      // ,
    );
  }
}
