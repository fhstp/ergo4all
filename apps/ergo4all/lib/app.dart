import 'package:common_ui/theme/theme.dart';
import 'package:custom_locale/custom_locale.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/language_screen.dart';
import 'package:ergo4all/onboarding/state.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:ergo4all/profile/storage/fs.dart';
import 'package:ergo4all/route_leave_observer.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:ergo4all/welcome/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Ergo4AllApp extends StatefulWidget {
  const Ergo4AllApp({super.key});

  @override
  State<Ergo4AllApp> createState() => _Ergo4AllAppState();
}

class _Ergo4AllAppState extends State<Ergo4AllApp> {
  Locale? _customLocale;

  void _lockPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _reloadCustomLocale() async {
    final customLocale = await tryGetCustomLocale();
    setState(() {
      _customLocale = customLocale;
    });
  }

  @override
  void initState() {
    super.initState();

    _lockPortraitMode();
    _reloadCustomLocale();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RulaSessionRepository>(
          create: (_) => FileBasedRulaSessionRepository(),
        ),
        Provider<ProfileRepo>(create: (_) => FileBasedProfileRepo()),
        Provider<OnboardingState>(create: (_) => PrefsOnboardingState()),
      ],
      child: MaterialApp(
        navigatorObservers: [
          RouteLeaveObserver(
            routeName: PickLanguageScreen.routeName,
            onLeft: _reloadCustomLocale,
          ),
        ],
        locale: _customLocale,
        title: 'Ergo4All',
        theme: ergo4allTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const WelcomeScreen(),
      ),
    );
  }
}
