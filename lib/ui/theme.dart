
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFFB7C9F7); // Softer blue
const Color softBluishClr = Color(0xFFE0E7FF); // Softer blue
const Color yellowClr = Color(0xFFFFF8E7); // Softer yellow
const Color pinkclr = Color(0xFFFFD1D7); // Softer pink
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

TextStyle get subHeadingStyle {
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey
    )
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato (
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato (
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato (
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600]
      )
  );
}

