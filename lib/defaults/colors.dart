import 'package:flutter/material.dart';

class ColorProvider {
  ColorProvider();

  /// is dark mode currently enabled?

  Map<String, Color> get widgetColors {
    return darkModeColor;
  }

  List<Color> get colorPalette {
    return darkcolorPalette;
  }

  Map<String, Color> lightModeColor = {
    'bg': Colors.white,
    'text': Colors.black
  };
  Map<String, Color> darkModeColor = {
    'bg': Colors.black,
    'text': Colors.white,
  };
}

//colors:
Color white = Colors.white;
Color black = const Color.fromARGB(255, 0, 0, 0);
Color heroOBlue = Colors.blue;
Color heroBlue = const Color.fromARGB(255, 56, 114, 255);
Color green = const Color.fromARGB(255, 75, 229, 80);
Color red = const Color.fromARGB(255, 251, 100, 100);
Color lightGrey = const Color.fromARGB(255, 238, 237, 235);
//light colors
Color orange = const Color.fromARGB(255, 255, 152, 67);
Color yellow = const Color.fromARGB(255, 253, 231, 103);
Color lightBlue = const Color.fromARGB(255, 104, 149, 210);
Color peach = const Color.fromARGB(255, 255, 155, 155);
Color skinColor = const Color.fromRGBO(255, 214, 165, 1);
Color bgIcon = const Color.fromARGB(170, 180, 180, 179);
List<Color> lightcolorPalette = [
  lightBlue,
  yellow,
  skinColor,
  peach,
  skinColor,
];

//dark colors
Color maroon = const Color.fromARGB(255, 117, 14, 33);
Color purple = const Color.fromARGB(255, 126, 37, 83);
Color darkBlue = const Color.fromARGB(255, 29, 43, 83);
Color navy = const Color.fromARGB(255, 18, 72, 107);
Color darkViolet = const Color.fromARGB(255, 34, 9, 44);
Color darkBrown = const Color.fromARGB(255, 61, 12, 17);
Color darkPurple = const Color.fromARGB(255, 51, 29, 44);
Color blackBlue = const Color.fromARGB(255, 3, 0, 28);
List<Color> darkcolorPalette = [
  maroon,
  darkPurple,
  purple,
  darkBlue,
  darkViolet,
  darkBrown,
];
