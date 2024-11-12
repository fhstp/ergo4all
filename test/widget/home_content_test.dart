import 'dart:async';

import 'package:ergo4all/home/content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_management/user_management.dart';

import '../integration/app_mock.dart';

void main() {
  testWidgets("should display user name if provided", (tester) async {
    final user = makeUserFromName("Jane");

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeContent(currentUserName: user.name)));

    expect(find.textContaining(user.name), findsOne);
  });

  testWidgets("should display shimmer if no user-name is provided",
      (tester) async {
    await tester
        .pumpWidget(makeMockAppFromWidget(HomeContent(currentUserName: null)));

    expect(find.byType(Shimmer), findsOne);
  });

  testWidgets("should show session start dialog when pressing start button",
      (tester) async {
    final completer = Completer();

    await tester.pumpWidget(makeMockAppFromWidget(HomeContent(
      onSessionRequested: () => completer.complete(),
    )));

    await tester.tap(find.byKey(const Key("start")));

    expect(completer.isCompleted, isTrue);
  });
}
