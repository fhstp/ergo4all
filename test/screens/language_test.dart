import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/screens/language.dart';
import 'package:ergo4all/screens/pre_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../mock_app.dart';
import '../mock_navigation_observer.dart';

void main() {
  final mockCustomLocaleProvider = CustomLocale(() async {
    return null;
  }, (_) async {});

  testWidgets("should navigate to next screen once language button is pressed",
      (tester) async {
    bool didNavigate = false;

    void onPushed(Route? oldRoute, Route? newRoute) {
      didNavigate = true;
    }

    await tester.pumpWidget(makeMockAppFromWidget(
        const LanguageScreen(),
        MockNavigationObserver(pushed: onPushed),
        [ChangeNotifierProvider(create: (_) => mockCustomLocaleProvider)]));

    await tester.tap(find.byKey(const Key("lang_button_deutsch")));
    await tester.pumpAndSettle();

    expect(didNavigate, isTrue);
    expect(find.byType(PreIntroScreen), findsOneWidget);
  });
}
