import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockingjay/mockingjay.dart';

Widget makeMockAppFromWidget(Widget widget, [MockNavigator? mockNavigator]) {
  final app = MaterialApp(
      title: "Mock Ergo4All",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MockNavigatorProvider(
        navigator: mockNavigator ?? MockNavigator(),
        child: widget,
      ));

  return app;
}
