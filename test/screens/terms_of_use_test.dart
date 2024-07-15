import 'package:ergo4all/screens/pre_user_creator.dart';
import 'package:ergo4all/screens/terms_of_use.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("should navigate to next screen once accepted", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TermsOfUseScreen()));

    await tester.tap(find.byKey(const Key("accept-check")));
    await tester.pumpAndSettle();

    expect(find.byType(PreUserCreatorScreen), findsOneWidget);
  });
}
