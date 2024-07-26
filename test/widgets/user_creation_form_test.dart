import 'package:ergo4all/screens/home.dart';
import 'package:ergo4all/widgets/user_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_app.dart';
import '../mock_navigation_observer.dart';

void main() {
  testWidgets("should not navigate to home if form is invalid", (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
        const Scaffold(body: UserCreationForm()), mockNavigationObserver));

    // Set nickname empty. This is an invalid value so we should not be able
    // to progress.
    await tester.enterText(find.byKey(const Key("nickNameInput")), "");

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isFalse);
  });

  testWidgets("should navigate to home if form is valid", (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
        const Scaffold(body: UserCreationForm()), mockNavigationObserver));

    await tester.enterText(
        find.byKey(const Key("nickNameInput")), "Some nickname");
    await tester.enterText(find.byKey(const Key("sexInput")), "M");

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
