import 'package:ergo4all/screens/pre_intro.dart';
import 'package:ergo4all/screens/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_navigation_observer.dart';

void main() {
  testWidgets("should navigate to next screen once language button is pressed",
      (tester) async {
    bool didNavigate = false;

    void onPushed(Route? oldRoute, Route? newRoute) {
      didNavigate = true;
    }

    await tester.pumpWidget(MaterialApp(
        navigatorObservers: [MockNavigationObserver(pushed: onPushed)],
        home: const LanguageScreen()));

    await tester.tap(find.byKey(const Key("lang_button_deutsch")));
    await tester.pumpAndSettle();

    expect(didNavigate, isTrue);
    expect(find.byType(PreIntroScreen), findsOneWidget);
  });
}
