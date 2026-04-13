import 'package:flutter/material.dart';

final Color _primary = Color(0xff0a0a0a);
final Color _onPrimary = Colors.purple;

final Color _secondary = Colors.purple;
final Color _onSecondary = Colors.white;

final Color _error = Colors.red;

// Modal Colors
final Color _titleColor = Colors.deepPurple;

// ElevatedButton
final Color _buttonColor = Colors.deepPurple;

// IconButton
final Color _backgroundColor = Colors.grey.shade900;
final Color _iconColor = Colors.deepPurple;

// SnackBar
final Color _snackBarBackgroundColor = Colors.grey.shade800;
final Color _snackBarContentColor = Colors.white;

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    primary: _primary,
    onPrimary: _onPrimary,

    secondary: _secondary,
    onSecondary: _onSecondary,

    error: _error,
  ),

  scaffoldBackgroundColor: _primary,

  dialogTheme: DialogThemeData(
    backgroundColor: _primary,
    titleTextStyle: TextStyle(
      color: _titleColor,
      fontSize: 30,
      fontWeight: FontWeight.w500,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(_buttonColor),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 40)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
    ),
  ),

  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(_backgroundColor),
      foregroundColor: WidgetStatePropertyAll(_iconColor),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.deepPurple.withValues(alpha: 0.2);
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.deepPurple.withValues(alpha: 0.1);
        }
        return null;
      }),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: _snackBarBackgroundColor,
    contentTextStyle: TextStyle(color: _snackBarContentColor),
  ),
);
