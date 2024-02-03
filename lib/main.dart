import 'package:flutter/material.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:coin_sage/firebase_options.dart';

//import 'package:coin_sage/authentication/screens/login.dart';
import 'package:coin_sage/screens/home_page.dart';
import 'package:coin_sage/defaults/colors.dart';
//import 'package:google_fonts/google_fonts.dart';

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

//Future
void main() {
//async {
  // await WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
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
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      // LoginScreen(),
    );
  }
}
