import 'package:ergo4all/app/common/routes.dart';
import 'package:ergo4all/app/pick_language/screen.dart';
import 'package:ergo4all/storage.custom_locale/pref_storage_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../app_mock.dart';
import '../fake_preference_storage.dart';

void main() {
  testWidgets("should navigate to next screen once language button is pressed",
      (tester) async {
    final navigator = makeDummyMockNavigator();
    final preferenceStorage = FakePreferenceStorage();

    await tester.pumpWidget(makeMockAppFromWidget(
      PickLanguageScreen(preferenceStorage),
      navigator,
    ));

    await tester.tap(find.byKey(const Key("lang_button_de")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushReplacementNamed(Routes.preIntro.path));
  });

  testWidgets("should store language when selected", (tester) async {
    final preferenceStorage = FakePreferenceStorage();

    await tester.pumpWidget(makeMockAppFromWidget(
      PickLanguageScreen(preferenceStorage),
    ));

    await tester.tap(find.byKey(const Key("lang_button_de")));
    await tester.pumpAndSettle();

    final storedLocale = await preferenceStorage.tryGetCustomLocale();
    expect(storedLocale, equals(const Locale("de")));
  });
}
