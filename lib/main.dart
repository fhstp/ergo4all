import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

    return ChangeNotifierProvider(
      create: (_) => CustomLocale.fromSharedPrefs(),
      child: MaterialApp(
          title: 'Ergo4All',
          theme: ThemeData(
            colorScheme: _colorScheme,
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const WelcomeScreen()),
    );
  }
}
