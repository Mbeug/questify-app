import 'package:flutter/material.dart';


final ThemeData appLightTheme = ThemeData(
colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
useMaterial3: true,
textTheme: const TextTheme(
headlineMedium: TextStyle(fontWeight: FontWeight.w600),
titleMedium: TextStyle(fontWeight: FontWeight.w600),
),
);


final ThemeData appDarkTheme = ThemeData(
colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1), brightness: Brightness.dark),
useMaterial3: true,
);