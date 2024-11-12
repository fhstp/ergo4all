import 'package:custom_locale_storage/pref_storage_ext.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/expert_intro_screen.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/live_analysis/screen.dart';
import 'package:ergo4all/non_expert_intro_screen.dart';
import 'package:ergo4all/pick_language/screen.dart';
import 'package:ergo4all/pre_intro_screen.dart';
import 'package:ergo4all/pre_user_creator_screen.dart';
import 'package:ergo4all/recorded_analysis/screen.dart';
import 'package:ergo4all/results_screen.dart';
import 'package:ergo4all/route_leave_observer.dart';
import 'package:ergo4all/terms_of_use_screen.dart';
import 'package:ergo4all/theme.dart';
import 'package:ergo4all/user_creator/screen.dart';
import 'package:ergo4all/welcome/screen.dart';
import 'package:ergo4all/welcome/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pose/mlkit.dart';
import 'package:pose/types.dart';
import 'package:prefs_storage/shared_preferences.dart';
import 'package:prefs_storage/types.dart';
import 'package:user_management/user_management.dart';

class Ergo4AllApp extends StatefulWidget {
  final UserStorage userStorage = PersistentUserStorage();
  final PreferenceStorage preferenceStorage = SharedPreferencesStorage();
  // ignore: prefer_function_declarations_over_variables
  final GetProjectVersion getProjectVersion =
      () => PackageInfo.fromPlatform().then((info) => info.version);
  final PoseDetector poseDetector = MLkitPoseDetectorAdapter();

  Ergo4AllApp({super.key});

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
          Routes.home.path: (context) => HomeScreen(
                userStorage: widget.userStorage,
              ),
          Routes.liveAnalysis.path: (context) => LiveAnalysisScreen(
                poseDetector: widget.poseDetector,
              ),
          Routes.recordedAnalysis.path: (context) =>
              const RecordedAnalysisScreen(),
          Routes.results.path: (context) => const ResultsScreen(),
          Routes.preIntro.path: (context) => const PreIntroScreen(),
          Routes.expertIntro.path: (context) => const ExpertIntroScreen(),
          Routes.nonExpertIntro.path: (context) => const NonExpertIntroScreen(),
          Routes.preUserCreator.path: (context) => PreUserCreatorScreen(
                userStorage: widget.userStorage,
              ),
          Routes.userCreator.path: (context) => UserCreatorScreen(
                userStorage: widget.userStorage,
              ),
          Routes.language.path: (context) =>
              PickLanguageScreen(widget.preferenceStorage),
          Routes.tou.path: (context) => const TermsOfUseScreen(),
          Routes.welcome.path: (context) => WelcomeScreen(
                getProjectVersion: widget.getProjectVersion,
                userStorage: widget.userStorage,
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
