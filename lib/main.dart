import 'package:ergo4all/io/local_file.dart';
import 'package:ergo4all/io/user_config.dart';
import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/screens/welcome.dart';
import 'package:ergo4all/service/add_user.dart';
import 'package:ergo4all/service/get_current_user.dart';
import 'package:ergo4all/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void _registerSingletons() {
  final getIt = GetIt.instance;

  getIt.registerSingleton<ReadLocalTextFile>(readLocalDocument);
  getIt.registerSingleton<WriteLocalTextFile>(writeLocalDocument);
  getIt.registerLazySingleton<GetUserConfig>(
      () => makeGetUserConfigFromStorage(getIt.get<ReadLocalTextFile>()));
  getIt.registerLazySingleton<GetCurrentUser>(
      () => makeGetCurrentUserFromConfig(getIt.get<GetUserConfig>()));
  getIt.registerLazySingleton<UpdateUserConfig>(() =>
      makeUpdateStoredUserConfig(
          getIt.get<GetUserConfig>(), getIt.get<WriteLocalTextFile>()));
  getIt.registerLazySingleton<AddUser>(
      () => makeAddUserToUserConfig(getIt.get<UpdateUserConfig>()));
}

void main() {
  _registerSingletons();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            locale: customLocale.customLocale,
            title: 'Ergo4All',
            theme: globalTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const WelcomeScreen());
      }),
    );
  }
}
