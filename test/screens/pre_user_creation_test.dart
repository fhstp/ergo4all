import 'dart:async';

import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/screens/home.dart';
import 'package:ergo4all/screens/pre_user_creator.dart';
import 'package:ergo4all/screens/user_creator.dart';
import 'package:ergo4all/service/add_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../mock_app.dart';
import '../mock_navigation_observer.dart';

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets(
      "should navigate to next screen once \"default values\" is selected",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();
    GetIt.instance.registerSingleton<AddUser>((_) async => null);
    await tester.pumpWidget(makeMockAppFromWidget(
        const PreUserCreatorScreen(), mockNavigationObserver));

    await tester.tap(find.byKey(const Key("default-values")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets("should create default user when \"default values\" is selected",
      (tester) async {
    final completer = Completer();
    GetIt.instance.registerSingleton<AddUser>((user) async {
      expect(user, equals(const User(name: "Ergo-fan")));
      completer.complete();
    });
    await tester
        .pumpWidget(makeMockAppFromWidget(const PreUserCreatorScreen()));

    await tester.tap(find.byKey(const Key("default-values")));
    await tester.pumpAndSettle();

    expect(completer.isCompleted, isTrue);
  });

  testWidgets("should navigate to user creator once create button is pressed",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();
    GetIt.instance.registerSingleton<AddUser>((_) async => null);
    await tester.pumpWidget(makeMockAppFromWidget(
        const PreUserCreatorScreen(), mockNavigationObserver));

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(UserCreatorScreen), findsOneWidget);
  });
}
