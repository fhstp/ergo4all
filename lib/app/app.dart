import 'package:ergo4all/app/common/routes.dart';
import 'package:ergo4all/app/expert_intro_screen.dart';
import 'package:ergo4all/app/home/screen.dart';
import 'package:ergo4all/app/live_analysis/screen.dart';
import 'package:ergo4all/app/non_expert_intro_screen.dart';
import 'package:ergo4all/app/pick_language/screen.dart';
import 'package:ergo4all/app/pre_intro_screen.dart';
import 'package:ergo4all/app/pre_user_creator_screen.dart';
import 'package:ergo4all/app/recorded_analysis/screen.dart';
import 'package:ergo4all/app/results_screen.dart';
import 'package:ergo4all/app/route_leave_observer.dart';
import 'package:ergo4all/app/terms_of_use_screen.dart';
import 'package:ergo4all/app/theme.dart';
import 'package:ergo4all/app/user_creator/screen.dart';
import 'package:ergo4all/app/welcome/screen.dart';
import 'package:ergo4all/pose.detection/types.dart';
import 'package:ergo4all/app/welcome/types.dart';
import 'package:ergo4all/storage.custom_locale/pref_storage_ext.dart';
import 'package:ergo4all/storage.prefs/types.dart';
import 'package:ergo4all/storage.text/types.dart';
import 'package:ergo4all/storage.video/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Ergo4AllApp extends StatefulWidget {
  final LocalTextStorage textStorage;
  final VideoStorage videoStorage;
  final PreferenceStorage preferenceStorage;
  final GetProjectVersion getProjectVersion;
  final PoseDetector poseDetector;

  const Ergo4AllApp(
      {super.key,
      required this.textStorage,
      required this.videoStorage,
      required this.preferenceStorage,
      required this.getProjectVersion,
      required this.poseDetector});

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
    final customLocale = await widget.preferenceStorage.tryGetCustomLocale();
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
          Routes.home.path: (context) =>
              HomeScreen(widget.videoStorage, widget.textStorage),
          Routes.liveAnalysis.path: (context) => LiveAnalysisScreen(
                poseDetector: widget.poseDetector,
              ),
          Routes.recordedAnalysis.path: (context) =>
              const RecordedAnalysisScreen(),
          Routes.results.path: (context) => const ResultsScreen(),
          Routes.preIntro.path: (context) => const PreIntroScreen(),
          Routes.expertIntro.path: (context) => const ExpertIntroScreen(),
          Routes.nonExpertIntro.path: (context) => const NonExpertIntroScreen(),
          Routes.preUserCreator.path: (context) =>
              PreUserCreatorScreen(widget.textStorage),
          Routes.userCreator.path: (context) =>
              UserCreatorScreen(widget.textStorage),
          Routes.language.path: (context) =>
              PickLanguageScreen(widget.preferenceStorage),
          Routes.tou.path: (context) => const TermsOfUseScreen(),
          Routes.welcome.path: (context) => WelcomeScreen(
                widget.textStorage,
                getProjectVersion: widget.getProjectVersion,
              )
        },
        navigatorObservers: [
          RouteLeaveObserver(
              routeName: Routes.language.path, onLeft: _reloadCustomLocale)
        ],
        locale: _customLocale,
        title: 'Ergo4All',
        theme: globalTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: Routes.welcome.path);
  }
}
