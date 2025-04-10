import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:flutter/material.dart';

const _colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: blueChill,
  onPrimary: white,
  secondary: tarawera,
  onSecondary: white,
  error: cardinal,
  onError: white,
  surface: white,
  onSurface: woodSmoke,
);

const _appBarTheme = AppBarTheme(
  backgroundColor: white,
  foregroundColor: woodSmoke,
  titleTextStyle: h1Style,
);

const _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    minimumSize: WidgetStatePropertyAll(Size(128, 48)),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(
        vertical: smallSpace,
        horizontal: mediumSpace,
      ),
    ),
    textStyle: WidgetStatePropertyAll(
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  ),
);

final _textTheme = TextTheme(
  headlineLarge: h1Style,
  headlineMedium: h3Style,
  headlineSmall: h4Style,
);

const _textButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    textStyle: WidgetStatePropertyAll(
      TextStyle(decoration: TextDecoration.underline),
    ),
  ),
);

/// The global ergo4all theme.
final ergo4allTheme = ThemeData(
  colorScheme: _colorScheme,
  appBarTheme: _appBarTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  textButtonTheme: _textButtonTheme,
  textTheme: _textTheme,
  fontFamily: 'Montserrat',
  useMaterial3: true,
);
