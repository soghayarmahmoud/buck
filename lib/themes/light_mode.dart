// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    inversePrimary: Colors.grey.shade900,
  ),

  cardTheme: CardThemeData(
    color: Colors.grey.shade300,
    elevation: 2.0,
    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  ),
);
