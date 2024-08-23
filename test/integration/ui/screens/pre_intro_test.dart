import 'package:ergo4all/ui/screens/pre_intro.dart';
import 'package:ergo4all/ui/screens/expert_intro.dart';
import 'package:ergo4all/ui/screens/terms_of_use.dart';
import 'package:ergo4all/ui/screens/non_expert_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../app_mock.dart';
import '../navigation_observer_mock.dart';

void main() {
  testWidgets("should navigate to professional intro when button is pressed",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
      const PreIntroScreen(),
      mockNavigationObserver,
    ));

    await tester.tap(find.byKey(const Key("expert")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(ExpertIntro), findsOneWidget);
  });

  testWidgets("should navigate to worker intro when button is pressed",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
      const PreIntroScreen(),
      mockNavigationObserver,
    ));

    await tester.tap(find.byKey(const Key("non-expert")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(NonExpertIntro), findsOneWidget);
  });

  testWidgets("should navigate to next screen once skip button is pressed",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
      const PreIntroScreen(),
      mockNavigationObserver,
    ));

    final skipButton = find.byKey(const Key("skip"));
    final scoll = find.byType(SingleChildScrollView);

    await tester.dragUntilVisible(skipButton, scoll, const Offset(0, 500));
    await tester.tap(skipButton);
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(TermsOfUseScreen), findsOneWidget);
  });
}
