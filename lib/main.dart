import 'package:ergo4all/app/custom_locale.dart';
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
import 'package:ergo4all/io/video_storage.dart';
import 'package:ergo4all/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

final textStorage = LocalDocumentStorage();
final videoStorage = GalleryVideoStorage(ImagePicker());

final Map<String, WidgetBuilder> _routes = {
  Routes.home.path: (context) => HomeScreen(videoStorage),
  Routes.analysis.path: (context) => const AnalysisScreen(),
  Routes.results.path: (context) => const ResultsScreen(),
  Routes.preIntro.path: (context) => const PreIntroScreen(),
  Routes.expertIntro.path: (context) => const ExpertIntro(),
  Routes.nonExpertIntro.path: (context) => const NonExpertIntro(),
  Routes.preUserCreator.path: (context) => PreUserCreatorScreen(textStorage),
  Routes.userCreator.path: (context) => UserCreatorScreen(textStorage),
  Routes.language.path: (context) => const LanguageScreen(),
  Routes.tou.path: (context) => const TermsOfUseScreen(),
  Routes.welcome.path: (context) => WelcomeScreen(
        textStorage,
      )
};

class Ergo4AllApp extends StatelessWidget {
  const Ergo4AllApp({super.key});

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
      child: Builder(builder: (context) {
        final customLocale = Provider.of<CustomLocale>(context);
        return MaterialApp(
            routes: _routes,
            locale: customLocale.customLocale,
            title: 'Ergo4All',
            theme: globalTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: Routes.welcome.path);
      }),
    );
  }
}

void main() {
  runApp(const Ergo4AllApp());
}
