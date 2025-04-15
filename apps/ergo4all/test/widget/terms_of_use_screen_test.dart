import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/terms_of_use/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget() {
    return Localizations(
      delegates: AppLocalizations.localizationsDelegates,
      locale: const Locale('en'),
      child: const TermsOfUseScreen(),
    );
  }

  testWidgets('should disable next button while not accepting terms',
      (tester) async {
    await tester.pumpWidget(buildTestWidget());

    final createButton = find.byKey(const Key('next'));
    expect(tester.widget<ElevatedButton>(createButton).enabled, isFalse);
  });

  testWidgets('should enable next button when accepting terms', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.byKey(const Key('accept-check')));
    await tester.pumpAndSettle();

    final createButton = find.byKey(const Key('next'));
    expect(tester.widget<ElevatedButton>(createButton).enabled, isTrue);
  });
}
