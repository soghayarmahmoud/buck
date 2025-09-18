// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300,
  ),
  cardTheme: CardThemeData(
    color: Colors.grey.shade800,
    elevation: 2.0,
    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  ),
);
