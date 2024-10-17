import 'package:ergo4all/app/io/custom_locale.dart';
import 'package:ergo4all/app/io/local_text_storage.dart';
import 'package:ergo4all/app/io/preference_storage.dart';
import 'package:ergo4all/app/io/video_storage.dart';
import 'package:ergo4all/app/post_language_nav_observer.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/app/screens/analysis_live.dart';
import 'package:ergo4all/app/screens/analysis_recorded.dart';
import 'package:ergo4all/app/screens/expert_intro.dart';
import 'package:ergo4all/app/screens/home.dart';
import 'package:ergo4all/app/screens/language.dart';
import 'package:ergo4all/app/screens/non_expert_intro.dart';
import 'package:ergo4all/app/screens/pre_intro.dart';
import 'package:ergo4all/app/screens/pre_user_creator.dart';
import 'package:ergo4all/app/screens/results.dart';
import 'package:ergo4all/app/screens/terms_of_use.dart';
import 'package:ergo4all/app/screens/user_creator.dart';
import 'package:ergo4all/app/ui/camera_permission_dialog.dart';
import 'package:ergo4all/app/ui/theme.dart';
import 'package:ergo4all/app/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Ergo4AllApp extends StatefulWidget {
  final LocalTextStorage textStorage;
  final VideoStorage videoStorage;
  final PreferenceStorage preferenceStorage;

  const Ergo4AllApp(
      {super.key,
      required this.textStorage,
      required this.videoStorage,
      required this.preferenceStorage});

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
    final customLocale = await tryGetCustomLocale(widget.preferenceStorage);
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
              requestCameraPermissions: () =>
                  showCameraPermissionDialog(context)),
          Routes.recordedAnalysis.path: (context) =>
              const RecordedAnalysisScreen(),
          Routes.results.path: (context) => const ResultsScreen(),
          Routes.preIntro.path: (context) => const PreIntroScreen(),
          Routes.expertIntro.path: (context) => const ExpertIntro(),
          Routes.nonExpertIntro.path: (context) => const NonExpertIntro(),
          Routes.preUserCreator.path: (context) =>
              PreUserCreatorScreen(widget.textStorage),
          Routes.userCreator.path: (context) =>
              UserCreatorScreen(widget.textStorage),
          Routes.language.path: (context) =>
              LanguageScreen(widget.preferenceStorage),
          Routes.tou.path: (context) => const TermsOfUseScreen(),
          Routes.welcome.path: (context) => WelcomeScreen(
                widget.textStorage,
              )
        },
        navigatorObservers: [
          PostLanguageNavObserver(_reloadCustomLocale)
        ],
        locale: _customLocale,
        title: 'Ergo4All',
        theme: globalTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: Routes.welcome.path);
  }
}
