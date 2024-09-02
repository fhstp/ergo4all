import 'package:ergo4all/app/impure_utils.dart';
import 'package:ergo4all/app/post_language_nav_observer.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/app/screens/analysis.dart';
import 'package:ergo4all/app/screens/expert_intro.dart';
import 'package:ergo4all/app/screens/home.dart';
import 'package:ergo4all/app/screens/language.dart';
import 'package:ergo4all/app/screens/non_expert_intro.dart';
import 'package:ergo4all/app/screens/pre_intro.dart';
import 'package:ergo4all/app/screens/pre_user_creator.dart';
import 'package:ergo4all/app/screens/results.dart';
import 'package:ergo4all/app/screens/terms_of_use.dart';
import 'package:ergo4all/app/screens/user_creator.dart';
import 'package:ergo4all/app/screens/welcome.dart';
import 'package:ergo4all/io/local_text_storage.dart';
import 'package:ergo4all/io/preference_storage.dart';
import 'package:ergo4all/io/video_storage.dart';
import 'package:ergo4all/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ergo4AllApp extends StatefulWidget {
  const Ergo4AllApp({super.key});

  @override
  State<Ergo4AllApp> createState() => _Ergo4AllAppState();
}

class _Ergo4AllAppState extends State<Ergo4AllApp> {
  late final LocalTextStorage _textStorage;
  late final VideoStorage _videoStorage;
  late final PreferenceStorage _preferenceStorage;
  Locale? _customLocale;

  void _lockPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _reloadCustomLocale() async {
    final customLocale = await tryGetCustomLocale(_preferenceStorage);
    setState(() {
      _customLocale = customLocale;
    });
  }

  @override
  void initState() {
    super.initState();
    _textStorage = LocalDocumentStorage();
    _videoStorage = GalleryVideoStorage(ImagePicker());
    _preferenceStorage = SharedPreferencesStorage(SharedPreferencesAsync());

    _lockPortraitMode();
    _reloadCustomLocale();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          Routes.home.path: (context) => HomeScreen(_videoStorage),
          Routes.analysis.path: (context) => const AnalysisScreen(),
          Routes.results.path: (context) => const ResultsScreen(),
          Routes.preIntro.path: (context) => const PreIntroScreen(),
          Routes.expertIntro.path: (context) => const ExpertIntro(),
          Routes.nonExpertIntro.path: (context) => const NonExpertIntro(),
          Routes.preUserCreator.path: (context) =>
              PreUserCreatorScreen(_textStorage),
          Routes.userCreator.path: (context) => UserCreatorScreen(_textStorage),
          Routes.language.path: (context) => LanguageScreen(_preferenceStorage),
          Routes.tou.path: (context) => const TermsOfUseScreen(),
          Routes.welcome.path: (context) => WelcomeScreen(
                _textStorage,
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

void main() {
  runApp(const Ergo4AllApp());
}
