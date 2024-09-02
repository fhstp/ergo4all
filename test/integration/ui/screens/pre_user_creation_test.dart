import 'dart:async';

import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/routes.dart';
import 'package:ergo4all/ui/screens/pre_user_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../app_mock.dart';

void main() {
  testWidgets(
      "should navigate to next screen once \"default values\" is selected",
      (tester) async {
    final navigator = makeDummyMockNavigator();
    await tester.pumpWidget(makeMockAppFromWidget(
        PreUserCreatorScreen(
          addUser: (_) async => null,
        ),
        navigator));

    await tester.tap(find.byKey(const Key("default-values")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamedAndRemoveUntil(Routes.home.path, any()));
  });

  testWidgets("should create default user when \"default values\" is selected",
      (tester) async {
    final completer = Completer();
    await tester.pumpWidget(makeMockAppFromWidget(PreUserCreatorScreen(
      addUser: (user) async {
        expect(user, equals(const User(name: "Ergo-fan")));
        completer.complete();
      },
    )));

    await tester.tap(find.byKey(const Key("default-values")));
    await tester.pumpAndSettle();

    expect(completer.isCompleted, isTrue);
  });

  testWidgets("should navigate to user creator once create button is pressed",
      (tester) async {
    final navigator = makeDummyMockNavigator();
    await tester.pumpWidget(makeMockAppFromWidget(
        PreUserCreatorScreen(
          addUser: (_) async => null,
        ),
        navigator));

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    verify(() => navigator.pushNamed(Routes.userCreator.path));
  });
}
