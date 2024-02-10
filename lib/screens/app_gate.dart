import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:coin_sage/authentication/screens/login.dart';
import 'package:coin_sage/screens/main/home_page.dart';

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //user is logged in
        if (snapshot.hasData) {
          return HomePage(user: snapshot.data!);
        }
        //user is NOT LOGGED in
        else {
          return const LoginScreen();
        }
      },
    );
  }
}
