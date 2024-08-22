import 'package:ergo4all/screens/pre_user_creator.dart';
import 'package:ergo4all/screens/terms_of_use.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../app_mock.dart';
import '../navigation_observer_mock.dart';

void main() {
  testWidgets("should disable next button while not accepting terms",
      (tester) async {
    await tester.pumpWidget(makeMockAppFromWidget(const TermsOfUseScreen()));

    final createButton = find.byKey(const Key("next"));
    expect(tester.widget<ElevatedButton>(createButton).enabled, isFalse);
  });

  testWidgets("should enable next button when accepting terms", (tester) async {
    await tester.pumpWidget(makeMockAppFromWidget(const TermsOfUseScreen()));

    await tester.tap(find.byKey(const Key("accept-check")));
    await tester.pumpAndSettle();

    final createButton = find.byKey(const Key("next"));
    expect(tester.widget<ElevatedButton>(createButton).enabled, isTrue);
  });

  testWidgets("should navigate to next screen on next button press",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
        const TermsOfUseScreen(), mockNavigationObserver));

    await tester.tap(find.byKey(const Key("accept-check")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key("next")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(PreUserCreatorScreen), findsOneWidget);
  });
}
