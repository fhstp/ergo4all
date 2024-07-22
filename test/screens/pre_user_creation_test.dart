import 'package:ergo4all/screens/home.dart';
import 'package:ergo4all/screens/pre_user_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_app.dart';
import '../mock_navigation_observer.dart';

void main() {
  testWidgets(
      "should navigate to next screen once \"default values\" is selected",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
        const PreUserCreatorScreen(), mockNavigationObserver));

    await tester.tap(find.byKey(const Key("default-values")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
