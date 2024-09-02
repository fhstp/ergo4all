import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/app/screens/terms_of_use.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../app_mock.dart';

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
    final navigator = makeDummyMockNavigator();

    await tester
        .pumpWidget(makeMockAppFromWidget(const TermsOfUseScreen(), navigator));

    await tester.tap(find.byKey(const Key("accept-check")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key("next")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushReplacementNamed(Routes.preUserCreator.path));
  });
}
