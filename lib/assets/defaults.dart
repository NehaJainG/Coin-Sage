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
Color green = const Color.fromARGB(255, 75, 229, 80);
Color red = const Color.fromARGB(255, 251, 100, 100);
//light colors
Color orange = const Color.fromARGB(255, 255, 152, 67);
Color yellow = const Color.fromARGB(255, 253, 231, 103);
Color lightBlue = const Color.fromARGB(255, 104, 149, 210);
Color peach = const Color.fromARGB(255, 255, 155, 155);
Color skinColor = const Color.fromRGBO(255, 214, 165, 1);
Color lightGreen = const Color.fromARGB(255, 203, 255, 169);
//dark colors
Color maroon = const Color.fromARGB(255, 117, 14, 33);
Color purple = const Color.fromARGB(255, 126, 37, 83);
Color darkBlue = const Color.fromARGB(255, 29, 43, 83);
Color navy = const Color.fromARGB(255, 18, 72, 107);
Color darkViolet = const Color.fromARGB(255, 34, 9, 44);
Color darkBrown = const Color.fromARGB(255, 61, 12, 17);
Color darkPurple = const Color.fromARGB(255, 51, 29, 44);
List<Color> colorPalette = [
  lightBlue,
  yellow,
  skinColor,
];

List<Color> darkcolorPalette = [
  maroon,
  darkPurple,
  purple,
  darkBlue,
  darkViolet,
  darkBrown,
];
Widget btwVertical = const SizedBox(height: 10);
EdgeInsetsGeometry dePadding = const EdgeInsets.all(10);
