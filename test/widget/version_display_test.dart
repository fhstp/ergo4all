import 'package:ergo4all/welcome/version_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestVersionDisplay(String? version) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: VersionDisplay(version: version));
  }

  testWidgets("should display static text when there is no version",
      (tester) async {
    await tester.pumpWidget(makeTestVersionDisplay(null));

    expect(find.text("..."), findsOne);
  });

  testWidgets("should display version text when there is a version",
      (tester) async {
    await tester.pumpWidget(makeTestVersionDisplay("1.2.3"));

    expect(find.text("v1.2.3"), findsOne);
  });
}
