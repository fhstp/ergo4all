import 'package:ergo4all/screens/professional_intro.dart';
import 'package:ergo4all/screens/terms_of_use.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_app.dart';
import '../mock_navigation_observer.dart';

void main() {
  testWidgets("should navigate to tos once done button is pressed",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
        const ProfessionalIntro(), mockNavigationObserver));

    await tester.tap(find.byKey(const Key("done")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(TermsOfUseScreen), findsOneWidget);
  });
}
