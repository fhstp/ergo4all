import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/home/session_start_dialog.dart';
import 'package:ergo4all/home/show_tutorial_dialog.dart';
import 'package:ergo4all/home/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_management/user_management.dart';

import '../app_mock.dart';
import '../fake_route.dart';
import '../fake_user_storage.dart';

void main() {
  late MockNavigator navigator;

  setUpAll(() {
    registerFallbackValue(FakeRoute<VideoSource>());
  });

  setUp(() {
    navigator = MockNavigator();

    when(navigator.canPop).thenReturn(true);

    when(() => navigator.push<VideoSource>(
            any(that: isRoute(whereName: equals(StartSessionDialog.name)))))
        .thenAnswer((_) async => null);

    when(() => navigator.push<bool>(
            any(that: isRoute(whereName: equals(ShowTutorialDialog.name)))))
        .thenAnswer((_) async => null);
  });

  testWidgets("should show session start dialog when pressing start button",
      (tester) async {
    final userStorage = FakeUserStorage();
    await userStorage.addUser(const User(name: "Jane", hasSeenTutorial: true));

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(userStorage: userStorage), navigator));

    await tester.tap(find.byKey(const Key("start")));

    verify(() => navigator.push<VideoSource>(
            any(that: isRoute(whereName: equals(StartSessionDialog.name)))))
        .called(1);
  });

  testWidgets("should display name of current user", (tester) async {
    final user = makeUserFromName("Jane");
    final userStorage = FakeUserStorage();
    await userStorage.addUser(user);

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(userStorage: userStorage), navigator));
    await tester.pump(Duration(milliseconds: 100));

    expect(find.textContaining(user.name), findsOne);
  });

  testWidgets("should show tutorial dialog if user has not seen it",
      (tester) async {
    final userStorage = FakeUserStorage();
    await userStorage.addUser(const User(name: "Jane", hasSeenTutorial: false));

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(userStorage: userStorage), navigator));

    verify(() => navigator.push<bool>(
            any(that: isRoute(whereName: equals(ShowTutorialDialog.name)))))
        .called(1);
  });

  testWidgets("should not show tutorial dialog if user has seen it",
      (tester) async {
    final userStorage = FakeUserStorage();
    await userStorage.addUser(const User(name: "Jane", hasSeenTutorial: true));

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(userStorage: userStorage), navigator));

    verifyNever(() => navigator.push<bool>(
        any(that: isRoute(whereName: equals(ShowTutorialDialog.name)))));
  });
}
