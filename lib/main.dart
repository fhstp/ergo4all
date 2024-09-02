import 'package:ergo4all/io/local_file.dart';
import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/routes.dart';
import 'package:ergo4all/service/add_user.dart';
import 'package:ergo4all/service/get_current_user.dart';
import 'package:ergo4all/service/user_config.dart';
import 'package:ergo4all/ui/screens/analysis.dart';
import 'package:ergo4all/ui/screens/expert_intro.dart';
import 'package:ergo4all/ui/screens/home.dart';
import 'package:ergo4all/ui/screens/language.dart';
import 'package:ergo4all/ui/screens/non_expert_intro.dart';
import 'package:ergo4all/ui/screens/pre_intro.dart';
import 'package:ergo4all/ui/screens/pre_user_creator.dart';
import 'package:ergo4all/ui/screens/results.dart';
import 'package:ergo4all/ui/screens/terms_of_use.dart';
import 'package:ergo4all/ui/screens/user_creator.dart';
import 'package:ergo4all/ui/screens/welcome.dart';
import 'package:ergo4all/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

final _getUserConfig = makeGetUserConfigFromStorage(readLocalDocument);
final _updateUserConfig =
    makeUpdateStoredUserConfig(_getUserConfig, writeLocalDocument);
final _addUser = makeAddUserToUserConfig(_updateUserConfig);
final _getCurrentUser = makeGetCurrentUserFromConfig(_getUserConfig);

final Map<String, WidgetBuilder> _routes = {
  Routes.home.path: (context) => const HomeScreen(),
  Routes.analysis.path: (context) => const AnalysisScreen(),
  Routes.results.path: (context) => const ResultsScreen(),
  Routes.preIntro.path: (context) => const PreIntroScreen(),
  Routes.expertIntro.path: (context) => const ExpertIntro(),
  Routes.nonExpertIntro.path: (context) => const NonExpertIntro(),
  Routes.preUserCreator.path: (context) => PreUserCreatorScreen(
        addUser: _addUser,
      ),
  Routes.userCreator.path: (context) => UserCreatorScreen(
        addUser: _addUser,
      ),
  Routes.language.path: (context) => const LanguageScreen(),
  Routes.tou.path: (context) => const TermsOfUseScreen(),
  Routes.welcome.path: (context) => WelcomeScreen(
        getCurrentUser: _getCurrentUser,
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
