import 'package:ergo4all/app/custom_locale.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/app/screens/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

import '../app_mock.dart';
import '../custom_locale_mock.dart';

void main() {
  testWidgets("should navigate to next screen once language button is pressed",
      (tester) async {
    final navigator = makeDummyMockNavigator();

    await tester.pumpWidget(makeMockAppFromWidget(
        const LanguageScreen(),
        navigator,
        [ChangeNotifierProvider(create: (_) => makeStubCustomLocale())]));

    await tester.tap(find.byKey(const Key("lang_button_de")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushReplacementNamed(Routes.preIntro.path));
  });

  testWidgets("should store language when selected", (tester) async {
    Locale? storedLocale;

    final mockCustomLocale = CustomLocale(() async {
      return null;
    }, (locale) async {
      storedLocale = locale;
    });

    await tester.pumpWidget(makeMockAppFromWidget(const LanguageScreen(), null,
        [ChangeNotifierProvider(create: (_) => mockCustomLocale)]));

    await tester.tap(find.byKey(const Key("lang_button_de")));
    await tester.pumpAndSettle();

    expect(storedLocale, equals(const Locale("de")));
  });
}
