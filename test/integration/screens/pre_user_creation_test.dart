import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/app/screens/pre_user_creator.dart';
import 'package:ergo4all/domain/user_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../app_mock.dart';
import '../fake_text_storage.dart';

void main() {
  testWidgets(
      "should navigate to next screen once \"default values\" is selected",
      (tester) async {
    final navigator = makeDummyMockNavigator();
    final textStorage = FakeTextStorage();
    await tester.pumpWidget(
        makeMockAppFromWidget(PreUserCreatorScreen(textStorage), navigator));

    await tester.tap(find.byKey(const Key("default-values")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamedAndRemoveUntil(Routes.home.path, any()));
  });

  testWidgets("should create default user when \"default values\" is selected",
      (tester) async {
    final textStorage = FakeTextStorage();
    await tester.pumpWidget(makeMockAppFromWidget(PreUserCreatorScreen(
      textStorage,
    )));

    await tester.tap(find.byKey(const Key("default-values")));
    await tester.pumpAndSettle();

    final userConfig = textStorage.tryGetUserConfig();
    expect(
        userConfig,
        equals(const UserConfig(currentUserIndex: 0, userEntries: [
          UserConfigEntry(name: "Ergo-fan", hasSeenTutorial: false)
        ])));
  });

  testWidgets("should navigate to user creator once create button is pressed",
      (tester) async {
    final navigator = makeDummyMockNavigator();
    final textStorage = FakeTextStorage();
    await tester.pumpWidget(
        makeMockAppFromWidget(PreUserCreatorScreen(textStorage), navigator));

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamed(Routes.userCreator.path));
  });
}
