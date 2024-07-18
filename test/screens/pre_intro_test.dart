import 'package:ergo4all/screens/pre_intro.dart';
import 'package:ergo4all/screens/terms_of_use.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_app.dart';
import '../mock_navigation_observer.dart';

void main() {
  testWidgets("should navigate to next screen once skip button is pressed",
      (tester) async {
    bool didNavigate = false;

    void onPushed(Route? oldRoute, Route? newRoute) {
      didNavigate = true;
    }

    await tester.pumpWidget(makeMockAppFromWidget(
      const PreIntroScreen(),
      MockNavigationObserver(pushed: onPushed),
    ));

    await tester.tap(find.byKey(const Key("skip")));
    await tester.pumpAndSettle();

    expect(didNavigate, isTrue);
    expect(find.byType(TermsOfUseScreen), findsOneWidget);
  });
}
