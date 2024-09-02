import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockingjay/mockingjay.dart';

/// Makes a basic [MockNavigator] which simply allows all navigation
/// requests and silently does nothing.
MockNavigator makeDummyMockNavigator() {
  final navigator = MockNavigator();
  when(navigator.canPop).thenReturn(true);
  when(() => navigator.pushNamed(any())).thenAnswer((_) async {
    return null;
  });
  when(() => navigator.pushReplacementNamed(any())).thenAnswer((_) async {
    return null;
  });
  when(() => navigator.pushNamedAndRemoveUntil(any(), any()))
      .thenAnswer((_) async {
    return null;
  });
  return navigator;
}

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
        navigator: mockNavigator ?? makeDummyMockNavigator(),
        child: widget,
      ));

  return app;
}
