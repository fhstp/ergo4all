import 'package:ergo4all/screens/intro.dart';
import 'package:ergo4all/screens/terms_of_use.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../app_mock.dart';
import '../navigation_observer_mock.dart';

void main() {
  final testPage = IntroPage(title: "Some title", widget: const Placeholder());

  testWidgets("should navigate to tos once done button is pressed",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
        Intro(
          pages: [testPage],
        ),
        mockNavigationObserver));

    await tester.tap(find.byKey(const Key("done")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(TermsOfUseScreen), findsOneWidget);
  });
}
