import 'package:ergo4all/routes.dart';
import 'package:ergo4all/ui/screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../app_mock.dart';

void main() {
  final testPage = IntroPage(title: "Some title", widget: const Placeholder());

  testWidgets("should navigate to tos once done button is pressed",
      (tester) async {
    final navigator = makeDummyMockNavigator();

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
