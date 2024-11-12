import 'package:ergo4all/common/intro.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../app_mock.dart';

void main() {
  final testPage = IntroPage(title: "Some title", widget: const Placeholder());

  late MockNavigator navigator;

  setUpAll(() {});

  setUp(() {
    navigator = MockNavigator();

    when(() => navigator.canPop()).thenReturn(true);
    when(() => navigator.pushNamed(any())).thenAnswer((_) async => null);
  });

  testWidgets("should navigate to tos once done button is pressed",
      (tester) async {
    await tester.pumpWidget(makeMockAppFromWidget(
        Intro(
          pages: [testPage],
        ),
        navigator));

    await tester.tap(find.byKey(const Key("done")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamed(Routes.tou.path));
  });
}
