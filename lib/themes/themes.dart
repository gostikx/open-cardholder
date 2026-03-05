import 'package:flutter/material.dart';

ThemeData defaultAppTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF001B3D), //background
    primary: Color(0xFFA4C9FF), //shades
    secondary: Color(0xFFA9C7FF), //buttons
    tertiary: Color(0xFF9CCAFF), //text
  ),
);
