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

final _appBarTheme = AppBarTheme(
  backgroundColor: white,
  foregroundColor: woodSmoke,
  titleTextStyle: h1Style,
);

final _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(Size(128, 48)),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(
        vertical: smallSpace,
        horizontal: mediumSpace,
      ),
    ),
    textStyle: WidgetStatePropertyAll(buttonLabelStyle),
    shape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  ),
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
  fontFamily: 'Montserrat',
  useMaterial3: true,
);
