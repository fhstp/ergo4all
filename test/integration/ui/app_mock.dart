import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

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

Widget makeMockAppFromWidget(Widget widget,
    [MockNavigator? mockNavigator, List<SingleChildWidget>? providers]) {
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

  return providers != null && providers.isNotEmpty
      ? MultiProvider(
          providers: providers,
          child: app,
        )
      : app;
}
