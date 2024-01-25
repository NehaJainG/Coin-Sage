import 'package:flutter/material.dart';

InputDecoration inputDecor(
    String label, Icon? prefixIcon, String? prefixText, String? hintText) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 15,
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

//colors:
Color black = const Color.fromARGB(255, 33, 33, 47);
Color blue = const Color.fromARGB(255, 56, 114, 255);

Widget btwVertical = const SizedBox(height: 10);
EdgeInsetsGeometry dePadding = const EdgeInsets.all(10);
