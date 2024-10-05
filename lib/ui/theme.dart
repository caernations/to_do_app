
import 'package:flutter/material.dart';


const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color (0xFFFFB746);
const Color pinkclr = Color(0xFFFf4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color (0xFF121212);
Color darkHeaderClr = const Color (0xFF424242);

class Themes {
  static final light = ThemeData(
    primaryColor: bluishClr,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,  // AppBar color for light theme
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: darkHeaderClr,  // AppBar color for dark theme
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}
