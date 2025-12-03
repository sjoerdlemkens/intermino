import 'package:flutter/material.dart';
import 'package:fasting_app/app/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class FastingTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: FastingColors.lightBlue,
        onPrimary: Colors.white,
        secondary: FastingColors.peach,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: FastingColors.lightGrey,
        onSurface: Colors.black,
      ),
    );
  }
}
