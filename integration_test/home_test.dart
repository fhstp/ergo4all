import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/home/show_tutorial_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:user_management/user_management.dart';

import 'app_robot.dart';
import 'onboarding_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(clearAppStorage);
  tearDown(clearAppStorage);

  group("home", () {
    testWidgets("scenario: open home for first time and skip tutorial",
        (tester) async {
      await openApp(tester);

      await completeOnboardingWithDefaultUser(tester);

      expect(find.byType(HomeScreen), findsOne);
      expect(find.byType(ShowTutorialDialog), findsOne);

      await tester.tap(find.byKey(Key("skip")));
      await tester.pumpAndSettle();

      expect(find.byType(ShowTutorialDialog), findsNothing);
    });

    testWidgets("scenario: open home with user who has seen tutorial",
        (tester) async {
      await addUser(User(name: "Cool user", hasSeenTutorial: true));

      await openApp(tester);

      await completeWelcomeScreen(tester);

      expect(find.byType(HomeScreen), findsOne);
      expect(find.byType(ShowTutorialDialog), findsNothing);
    });
  });
}
