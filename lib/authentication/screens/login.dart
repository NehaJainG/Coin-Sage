import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/strings.dart';
import 'package:coin_sage/authentication/widgets/signup.dart';
import 'package:coin_sage/authentication/widgets/signin.dart';
import 'package:coin_sage/authentication/widgets/login_header.dart';
import 'package:coin_sage/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  String activeScreen = signin;

  void changeScreen(String toScreen) {
    setState(() {
      activeScreen = toScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = activeScreen == signin
        ? SignIn(
            changeToSignup: changeScreen,
          )
        : SignUp(
            changeToSignin: changeScreen,
          );
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                LoginHeader(
                  header: activeScreen == signin ? signinHead : signupHead,
                  subMessage: activeScreen == signin ? signinSub : signupSub,
                ),
                content,
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: const Text('Home Page'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
