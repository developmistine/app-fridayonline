import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';

ThemeData themeData() {
  return ThemeData(
    primaryColor: theme_color_df,
    fontFamily: 'notoreg',
    useMaterial3: false,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: theme_color_df),
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: 'notoreg',
          fontWeight: FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        textStyle: const TextStyle(
          fontFamily: 'notoreg',
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          // Customize button shape
          borderRadius: BorderRadius.circular(30.0),
        ),
        textStyle: const TextStyle(
          fontFamily: 'notoreg',
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}
