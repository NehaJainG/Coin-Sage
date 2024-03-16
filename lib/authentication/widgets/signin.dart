import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/authentication/firebase_auth/firebase_auth_servies.dart';

import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/strings.dart';
import 'package:coin_sage/presentation/personal/home_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    super.key,
    required this.changeToSignup,
  });

  final void Function(String) changeToSignup;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void authenticate() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(user: user),
          ),
        );
        return;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: nFormPadding - 15),
          TextFormField(
              controller: _emailController,
              decoration: inputDecor(
                'Email Id',
                person,
                null,
                'example@gmail.com',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty || !isValidEmail(value)) {
                  return 'Enter a valid email';
                }
                return null;
              }),
          SizedBox(height: nFormPadding - 15),
          TextFormField(
            controller: _passwordController,
            decoration: inputDecor(
              'Password',
              password,
              null,
              'password',
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must have atleast 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: nFormPadding - 30),
          const Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: null,
              child: Text('Forgot Password?'),
            ),
          ),
          SizedBox(height: nFormPadding - 25),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: ElevatedButton(
              onPressed: authenticate,
              child: const Text('LOGIN'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                widget.changeToSignup(signup);
              },
              child: const Text('Don\'t have account? Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}
