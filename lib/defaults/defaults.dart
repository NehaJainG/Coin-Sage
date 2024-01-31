import 'package:flutter/material.dart';

InputDecoration inputDecor(
    String label, Icon? prefixIcon, String? prefixText, String? hintText) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 20,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    labelText: label,
    prefixIcon: prefixIcon,
    prefixText: prefixText,
    hintText: hintText,
  );
}

FloatingActionButton exitButton(BuildContext context) => FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      backgroundColor: Colors.white10,
      splashColor: Colors.white38,
      elevation: 0,
      mini: true,
      tooltip: 'Tap to exit',
      child: const Icon(
        Icons.close_rounded,
        color: Colors.black,
        size: 30,
      ),
    );

Widget btwVertical = const SizedBox(height: 10);
EdgeInsetsGeometry dePadding = const EdgeInsets.all(10);
EdgeInsetsGeometry listMargin = const EdgeInsets.symmetric(horizontal: 6);
double nFormPadding = 30;

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}
