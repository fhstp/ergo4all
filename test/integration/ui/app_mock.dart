import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'navigation_observer_mock.dart';

Widget makeMockAppFromWidget(Widget widget,
    [MockNavigationObserver? navigationObserver,
    List<SingleChildWidget>? providers]) {
  final app = MaterialApp(
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

  return providers != null && providers.isNotEmpty
      ? MultiProvider(
          providers: providers,
          child: app,
        )
      : app;
}
