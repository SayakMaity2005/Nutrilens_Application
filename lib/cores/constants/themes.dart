import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    extensions: [ThemePalette.lightPalette],
  );
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    extensions: [ThemePalette.darkPalette],
  );
}
