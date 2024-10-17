import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/app/ui/user_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeForm(void Function(User user) onUserSubmitted) {
    return MaterialApp(
      locale: const Locale("en"),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: UserCreationForm(
          onUserSubmitted: onUserSubmitted,
        ),
      ),
    );
  }

  testWidgets("should not submit user if form is invalid", (tester) async {
    User? submittedUser;

    await tester.pumpWidget(makeForm(
      (user) => submittedUser = user,
    ));

    // Set nickname empty. This is an invalid value so we should not be able
    // to progress.
    await tester.enterText(find.byKey(const Key("nickNameInput")), "");

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(submittedUser, null);
  });

  testWidgets("should submit user if form is valid", (tester) async {
    User? submittedUser;

    await tester.pumpWidget(makeForm(
      (user) => submittedUser = user,
    ));

    await tester.enterText(find.byKey(const Key("nickNameInput")), "John");

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(submittedUser, null);
  });
}
