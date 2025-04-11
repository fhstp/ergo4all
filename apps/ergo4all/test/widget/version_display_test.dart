import 'package:ergo4all/welcome/version_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  Widget makeTestVersionDisplay(Option<String> version) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: VersionDisplay(version: version),
    );
  }

  testWidgets('should display static text when there is no version',
      (tester) async {
    await tester.pumpWidget(makeTestVersionDisplay(none()));

    expect(find.text('...'), findsOne);
  });

  testWidgets('should display version text when there is a version',
      (tester) async {
    await tester.pumpWidget(makeTestVersionDisplay(const Some('1.2.3')));

    expect(find.text('v1.2.3'), findsOne);
  });
}
