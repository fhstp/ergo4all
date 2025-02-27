import 'package:ergo4all/home/user_welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_management/user_management.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';

void main() {
  Widget buildTestWidget(User user) {
    return Localizations(
        delegates: AppLocalizations.localizationsDelegates,
        locale: Locale("en"),
        child: UserWelcomeHeader(user));
  }

  testWidgets("should display name of user", (tester) async {
    final user = makeUserFromName("Jane");

    await tester.pumpWidget(buildTestWidget(user));

    expect(find.textContaining(user.name), findsOne);
  });
}
