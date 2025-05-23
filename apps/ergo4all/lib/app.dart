import 'package:common/casting.dart';
import 'package:common_ui/theme/theme.dart';
import 'package:custom_locale/custom_locale.dart';
import 'package:ergo4all/analysis/common.dart';
import 'package:ergo4all/analysis/live/screen.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/imprint_screen.dart';
import 'package:ergo4all/language_screen.dart';
import 'package:ergo4all/privacy_screen.dart';
import 'package:ergo4all/results/detail/screen.dart';
import 'package:ergo4all/results/overview/screen.dart';
import 'package:ergo4all/route_leave_observer.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/scenario/scenario_choice_screen.dart';
import 'package:ergo4all/scenario/scenario_detail_screen.dart';
import 'package:ergo4all/tips/tip_choice_screen.dart';
import 'package:ergo4all/tips/tip_detail_screen.dart';
import 'package:ergo4all/welcome/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility function for getting the current route args casted as a specific
/// type [T].
T _getRouteArgs<T extends Object>(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments?.tryAs<T>();

  assert(args != null, 'Incorrect route args');

  return args!;
}

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
    return MaterialApp(
      routes: {
        Routes.home.path: (context) => const HomeScreen(),
        Routes.scenarioChoice.path: (context) => const ScenarioChoiceScreen(),
        Routes.scenarioDetail.path: (context) {
          final scenario = _getRouteArgs<Scenario>(context);
          return ScenarioDetailScreen(scenario: scenario);
        },
        Routes.liveAnalysis.path: (context) {
          final scenario = _getRouteArgs<Scenario>(context);
          return LiveAnalysisScreen(scenario: scenario);
        },
        Routes.resultsOverview.path: (context) {
          final analysisResult = _getRouteArgs<AnalysisResult>(context);
          return ResultsOverviewScreen(analysisResult: analysisResult);
        },
        Routes.resultsDetail.path: (context) {
          final analysisResult = _getRouteArgs<AnalysisResult>(context);
          return ResultsDetailScreen(analysisResult: analysisResult);
        },
        Routes.language.path: (context) => const PickLanguageScreen(),
        Routes.welcome.path: (context) => const WelcomeScreen(),
        Routes.tipChoice.path: (context) => const TipChoiceScreen(),
        Routes.tipDetail.path: (context) => const TipDetailScreen(),
        Routes.imprint.path: (_) => const ImprintScreen(),
        Routes.privacy.path: (_) => const PrivacyScreen(),
      },
      navigatorObservers: [
        RouteLeaveObserver(
          routeName: Routes.language.path,
          onLeft: _reloadCustomLocale,
        ),
      ],
      locale: _customLocale,
      title: 'Ergo4All',
      theme: ergo4allTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: Routes.welcome.path,
    );
  }
}
