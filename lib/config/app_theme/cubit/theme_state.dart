import 'package:flutter/material.dart';

// Light Theme Colors
const Color lightPrimary = Color(0xFF405DE6);
const Color lightBackground = Color(0xFFF8F8F8);
const Color lightScaffoldBackground = Color(0xFFF8F8F8);
const Color lightTextPrimary = Color(0xFF262626);
const Color lightTextSecondary = Color(0xFF8E8E8E);
const Color lightTextHint = Color(0xFFB2B2B2);
const Color lightTextDisabled = Color(0xFFDADADA);
const Color lightIconPrimary = Color(0xFF262626);
const Color lightBorder = Color(0xFFDBDBDB);

// Dark Theme Colors
const Color darkPrimary = Color(0xFF833AB4);
const Color darkBackground = Color(0xFF121212);
const Color darkScaffoldBackground = Color(0xFF181818);
const Color darkTextPrimary = Color(0xFFE0E0E0);
const Color darkTextSecondary = Color(0xFFB3B3B3);
const Color darkTextHint = Color(0xFF757575);
const Color darkTextDisabled = Color(0xFF404040);
const Color darkIconPrimary = Color(0xFFE0E0E0);
const Color darkBorder = Color(0xFF404040);

sealed class ThemeState {
  final ThemeData themeData;
  final bool isDark;

  const ThemeState(this.themeData, this.isDark);
}

class LightThemeState extends ThemeState {
  LightThemeState()
      : super(
          ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: lightScaffoldBackground,
            colorScheme: ColorScheme.light(primary: lightPrimary),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: lightTextPrimary),
              bodyMedium: TextStyle(color: lightTextPrimary),
              bodySmall: TextStyle(color: lightTextSecondary),
              titleLarge: TextStyle(color: lightTextPrimary),
              titleMedium: TextStyle(color: lightTextPrimary),
              titleSmall: TextStyle(color: lightTextSecondary),
              labelLarge: TextStyle(color: lightTextPrimary),
              labelMedium: TextStyle(color: lightTextSecondary),
              labelSmall: TextStyle(color: lightTextHint),
            ),
            iconTheme: const IconThemeData(color: lightIconPrimary),
            disabledColor: lightTextDisabled,
            dividerColor: lightBorder,
          ),
          false,
        );
}

class DarkThemeState extends ThemeState {
  DarkThemeState()
      : super(
          ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: darkScaffoldBackground,
            colorScheme: ColorScheme.dark(primary: darkPrimary),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: darkTextPrimary),
              bodyMedium: TextStyle(color: darkTextPrimary),
              bodySmall: TextStyle(color: darkTextSecondary),
              titleLarge: TextStyle(color: darkTextPrimary),
              titleMedium: TextStyle(color: darkTextPrimary),
              titleSmall: TextStyle(color: darkTextSecondary),
              labelLarge: TextStyle(color: darkTextPrimary),
              labelMedium: TextStyle(color: darkTextSecondary),
              labelSmall: TextStyle(color: darkTextHint),
            ),
            iconTheme: const IconThemeData(color: darkIconPrimary),
            disabledColor: darkTextDisabled,
            dividerColor: darkBorder,
          ),
          true,
        );
}