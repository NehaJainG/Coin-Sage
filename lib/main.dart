import 'package:coin_sage/services/push_notification.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:coin_sage/firebase_options.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/screens/app_gate.dart';

final customisedTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: heroBlue,
  ),

  //textTheme: GoogleFonts.poppinsTextTheme(),
);
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: heroBlue,
  ),

  //textTheme: GoogleFonts.poppinsTextTheme(),
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  PushNotifications.requestNotificationPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Sage',
      theme: customisedTheme,
      darkTheme: darkTheme,
      home: const AppGate(),
      debugShowCheckedModeBanner: false,
      // ,
    );
  }
}
