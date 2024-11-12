import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/pre_user_creator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_management/user_management.dart';

import '../app_mock.dart';
import '../fake_user_storage.dart';

void main() {
  late MockNavigator navigator;

  setUpAll(() {});

  setUp(() {
    navigator = MockNavigator();

    when(() => navigator.canPop()).thenReturn(true);
    when(() => navigator.pushNamed(any())).thenAnswer((_) async => null);
    when(() => navigator.pushNamedAndRemoveUntil(any(), any()))
        .thenAnswer((_) async => null);
  });

  testWidgets(
      "should navigate to next screen once \"default values\" is selected",
      (tester) async {
    final userStorage = FakeUserStorage();
    await tester.pumpWidget(makeMockAppFromWidget(
        PreUserCreatorScreen(userStorage: userStorage), navigator));

    await tester.tap(find.byKey(const Key("default-values")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamedAndRemoveUntil(Routes.home.path, any()));
  });

  testWidgets("should create default user when \"default values\" is selected",
      (tester) async {
    final userStorage = FakeUserStorage();
    await tester.pumpWidget(makeMockAppFromWidget(
        PreUserCreatorScreen(userStorage: userStorage), navigator));

    await tester.tap(find.byKey(const Key("default-values")));
    await tester.pumpAndSettle();

    final user = await userStorage.getCurrentUser();
    expect(user, equals(User(name: "Ergo-fan", hasSeenTutorial: false)));
  });

  testWidgets("should navigate to user creator once create button is pressed",
      (tester) async {
    final userStorage = FakeUserStorage();
    await tester.pumpWidget(makeMockAppFromWidget(
        PreUserCreatorScreen(userStorage: userStorage), navigator));

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamed(Routes.userCreator.path));
  });
}
