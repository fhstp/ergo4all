import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  style: elevatedButtonStyle,
);

final _textButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    textStyle: WidgetStatePropertyAll(
      GoogleFonts.nunito(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        decoration: TextDecoration.underline,
      ),
    ),
    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
    splashFactory: NoSplash.splashFactory,
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
