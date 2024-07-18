import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'mock_navigation_observer.dart';

MaterialApp makeMockAppFromWidget(Widget widget,
    [MockNavigationObserver? navigationObserver]) {
  return MaterialApp(
      title: "Mock Ergo4All",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers:
          navigationObserver != null ? [navigationObserver] : [],
      home: widget);
}
