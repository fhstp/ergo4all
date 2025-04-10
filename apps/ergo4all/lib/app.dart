import 'package:common_ui/theme/theme.dart';
import 'package:custom_locale/custom_locale.dart';
import 'package:ergo4all/analysis/live/screen.dart';
import 'package:ergo4all/analysis/results_screen.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/onboarding/expert_intro_screen.dart';
import 'package:ergo4all/onboarding/non_expert_intro_screen.dart';
import 'package:ergo4all/onboarding/pick_language_screen.dart';
import 'package:ergo4all/onboarding/pre_intro_screen.dart';
import 'package:ergo4all/onboarding/pre_user_creator_screen.dart';
import 'package:ergo4all/onboarding/terms_of_use_screen.dart';
import 'package:ergo4all/onboarding/user_creator_screen.dart';
import 'package:ergo4all/route_leave_observer.dart';
import 'package:ergo4all/scenario/scenario_choice_screen.dart';
import 'package:ergo4all/scenario/scenario_detail_screen.dart';
import 'package:ergo4all/welcome/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _reloadCustomLocale() async {
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
    return MaterialApp(
        routes: {
          Routes.home.path: (context) => HomeScreen(),
          Routes.scenarioChoice.path: (context) => ScenarioChoiceScreen(),
          Routes.scenarioDetail.path: (context) => ScenarioDetailScreen(),
          Routes.liveAnalysis.path: (context) => LiveAnalysisScreen(),
          Routes.results.path: (context) => const ResultsScreen(),
          Routes.preIntro.path: (context) => const PreIntroScreen(),
          Routes.expertIntro.path: (context) => const ExpertIntroScreen(),
          Routes.nonExpertIntro.path: (context) => const NonExpertIntroScreen(),
          Routes.preUserCreator.path: (context) => PreUserCreatorScreen(),
          Routes.userCreator.path: (context) => UserCreatorScreen(),
          Routes.language.path: (context) => PickLanguageScreen(),
          Routes.tou.path: (context) => const TermsOfUseScreen(),
          Routes.welcome.path: (context) => WelcomeScreen()
        },
        navigatorObservers: [
          RouteLeaveObserver(
              routeName: Routes.language.path, onLeft: _reloadCustomLocale)
        ],
        locale: _customLocale,
        title: 'Ergo4All',
        theme: ergo4allTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: Routes.welcome.path);
  }
}
