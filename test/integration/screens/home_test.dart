import 'package:ergo4all/dialogs/session_start.dart';
import 'package:ergo4all/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../app_mock.dart';
import '../navigation_observer_mock.dart';

void main() {
  testWidgets("should show session start dialog when pressing start button",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(
        makeMockAppFromWidget(const HomeScreen(), mockNavigationObserver));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("start")));
      await tester.pump();
    });

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byKey(StartSessionDialog.dialogKey), findsOneWidget);
  });
}
