import 'package:coin_sage/authentication/firebase_auth/firebase_auth_servies.dart';
import 'package:coin_sage/screens/main/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/strings.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    super.key,
    required this.changeToSignin,
  });

  final void Function(String) changeToSignin;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void createAccount() async {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
              controller: _nameController,
              decoration: inputDecor(
                'Name',
                person,
                null,
                'Enter your name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 2) {
                  return 'Must be more than 2 characters';
                }
                return null;
              }),
          SizedBox(height: nFormPadding - 15),
          TextFormField(
            controller: _emailController,
            decoration: inputDecor(
              'Email',
              email,
              null,
              'Enter your email id',
            ),
            validator: (value) {
              if (value == null || value.isEmpty || !isValidEmail(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: nFormPadding - 15),
          TextFormField(
            controller: _passwordController,
            decoration: inputDecor(
              'Password',
              password,
              null,
              null,
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must have atleast 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: nFormPadding - 15),
          TextFormField(
            decoration: inputDecor(
              'Confirm Password',
              password,
              null,
              null,
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must have atleast 6 characters';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: nFormPadding),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: ElevatedButton(
              onPressed: createAccount,
              child: const Text('SIGN UP'),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.changeToSignin(signin);
            },
            child: const Text('Already have accout? Sign in'),
          )
        ],
      ),
    );
  }

  void _signUp() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signUpWithEmailAndPassword(email, password, name);

    if (user != null) {
      print("User is successfully created");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(user: user),
        ),
      );
    } else {
      print('Error');
    }
  }
}
