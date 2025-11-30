import 'package:flutter/material.dart';
import 'package:fasting_app/app/theme/theme.dart';

class FastingTheme {
  static ThemeData get light {
    return ThemeData(
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
