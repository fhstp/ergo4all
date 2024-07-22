import 'package:flutter/material.dart';

const _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFE0000),
    onPrimary: Color(0xFF212121),
    secondary: Color(0xFF00FEFE),
    onSecondary: Color(0xFF757575),
    error: Color(0xFFB00020),
    onError: Color(0xFF757575),
    surface: Color(0xFFF5F5F5),
    onSurface: Color(0xFF212121));

final globalTheme = ThemeData(
  colorScheme: _colorScheme,
  fontFamily: "Montserrat",
  useMaterial3: true,
);
