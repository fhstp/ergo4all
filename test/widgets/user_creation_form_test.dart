import 'dart:async';
import 'package:ergo4all/screens/home.dart';
import 'package:ergo4all/service/add_user.dart';
import 'package:ergo4all/widgets/user_creation_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../mock_app.dart';
import '../mock_navigation_observer.dart';

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets("should not navigate to home if form is invalid", (tester) async {
    final mockNavigationObserver = MockNavigationObserver();
    GetIt.instance.registerSingleton<AddUser>((_) async => null);
    await tester.pumpWidget(makeMockAppFromWidget(
        const Scaffold(body: UserCreationForm()), mockNavigationObserver));

    // Set nickname empty. This is an invalid value so we should not be able
    // to progress.
    await tester.enterText(find.byKey(const Key("nickNameInput")), "");

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isFalse);
  });

  testWidgets("should navigate to home if form is valid", (tester) async {
    final mockNavigationObserver = MockNavigationObserver();
    GetIt.instance.registerSingleton<AddUser>((_) async => null);
    await tester.pumpWidget(makeMockAppFromWidget(
        const Scaffold(body: UserCreationForm()), mockNavigationObserver));

    await tester.enterText(
        find.byKey(const Key("nickNameInput")), "Some nickname");
    await tester.enterText(find.byKey(const Key("sexInput")), "M");

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets("should create user with entered data", (tester) async {
    Completer completer = Completer();

    const someNickName = "John";
    GetIt.instance.registerSingleton<AddUser>((user) async {
      expect(user.name, equals(someNickName));
      // TODO: Test other user properties
      completer.complete();
    });

    await tester.pumpWidget(
        makeMockAppFromWidget(const Scaffold(body: UserCreationForm())));

    await tester.enterText(
        find.byKey(const Key("nickNameInput")), someNickName);
    await tester.enterText(find.byKey(const Key("sexInput")), "M");

    await tester.tap(find.byKey(const Key("create")));
    await tester.pumpAndSettle();

    expect(completer.isCompleted, isTrue);
  });
}
