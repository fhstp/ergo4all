import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/ui/widgets/user_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../integration/ui/app_mock.dart';

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets("should not submit user if form is invalid", (tester) async {
    User? submittedUser;

    await tester.pumpWidget(makeMockAppFromWidget(Scaffold(
        body: UserCreationForm(
      onUserSubmitted: (user) => submittedUser = user,
    ))));

    // Set nickname empty. This is an invalid value so we should not be able
    // to progress.
    await tester.enterText(find.byKey(const Key("nickNameInput")), "");

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(submittedUser, null);
  });

  testWidgets("should submit user if form is valid", (tester) async {
    User? submittedUser;

    await tester.pumpWidget(makeMockAppFromWidget(Scaffold(
        body: UserCreationForm(
      onUserSubmitted: (user) => submittedUser = user,
    ))));

    await tester.enterText(find.byKey(const Key("nickNameInput")), "John");

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(submittedUser, null);
  });
}
