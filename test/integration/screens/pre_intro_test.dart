import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/app/screens/pre_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../app_mock.dart';

void main() {
  testWidgets("should navigate to professional intro when button is pressed",
      (tester) async {
    final navigator = makeDummyMockNavigator();

    await tester.pumpWidget(makeMockAppFromWidget(
      const PreIntroScreen(),
      navigator,
    ));

    await tester.tap(find.byKey(const Key("expert")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamed(Routes.expertIntro.path));
  });

  testWidgets("should navigate to worker intro when button is pressed",
      (tester) async {
    final navigator = makeDummyMockNavigator();

    await tester.pumpWidget(makeMockAppFromWidget(
      const PreIntroScreen(),
      navigator,
    ));

    await tester.tap(find.byKey(const Key("non-expert")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamed(Routes.nonExpertIntro.path));
  });

  testWidgets("should navigate to next screen once skip button is pressed",
      (tester) async {
    final navigator = makeDummyMockNavigator();

    await tester
        .pumpWidget(makeMockAppFromWidget(const PreIntroScreen(), navigator));

    final skipButton = find.byKey(const Key("skip"));
    final scoll = find.byType(SingleChildScrollView);

    await tester.dragUntilVisible(skipButton, scoll, const Offset(0, 500));
    await tester.tap(skipButton);
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamed(Routes.tou.path));
  });
}
