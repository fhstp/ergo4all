import 'package:ergo4all/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFFE0000),
      onPrimary: Color(0xFF212121),
      secondary: Color(0xFF00FEFE),
      onSecondary: Color(0xFF757575),
      error: Color(0xFFB00020),
      onError: Color(0xFF757575),
      surface: Color(0xFFF5F5F5),
      onSurface: Color(0xFF212121));

  void _lockPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _lockPortraitMode();

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: _colorScheme,
          useMaterial3: true,
        ),
        home: const WelcomeScreen());
  }
}
