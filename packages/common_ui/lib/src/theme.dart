import 'package:common_ui/src/spacing.dart';
import 'package:flutter/material.dart';

const _primaryHovered = Color(0xFFFF6666);
const _primaryPressed = Color(0xFFB20000);
const _disabled = Color(0xFFBDBDBD);

const _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFE0000),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF00FEFE),
    onSecondary: Color(0xFF757575),
    error: Color(0xFFB00020),
    onError: Color(0xFF757575),
    surface: Color(0xFFF5F5F5),
    onSurface: Color(0xFF212121));

const _h1Style = TextStyle(fontWeight: FontWeight.w500, fontSize: 24);

final _appBarTheme = AppBarTheme(
    backgroundColor: _colorScheme.primary,
    foregroundColor: _colorScheme.onPrimary,
    titleTextStyle: _h1Style);

final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return _disabled;
          }
          if (states.contains(WidgetState.pressed)) {
            return _primaryPressed;
          } else if (states.contains(WidgetState.hovered)) {
            return _primaryHovered;
          }
          return _colorScheme.primary;
        }),
        foregroundColor: WidgetStatePropertyAll(_colorScheme.onPrimary),
        minimumSize: const WidgetStatePropertyAll(Size(128, 48)),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(
            vertical: smallSpace, horizontal: mediumSpace)),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))))));

const _textTheme = TextTheme(headlineLarge: _h1Style);

final _textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(_colorScheme.onSurface),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(decoration: TextDecoration.underline))));

final globalTheme = ThemeData(
  colorScheme: _colorScheme,
  appBarTheme: _appBarTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  textButtonTheme: _textButtonTheme,
  textTheme: _textTheme,
  fontFamily: "Montserrat",
  useMaterial3: true,
);
