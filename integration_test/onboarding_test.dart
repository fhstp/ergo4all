import 'package:ergo4all/home/screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:user_management/user_management.dart';

import 'app_robot.dart';
import 'onboarding_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("onboarding", () {
    setUpAll(clearAppStorage);
    tearDown(clearAppStorage);

    testWidgets("scenario: skip past everything", (tester) async {
      await openApp(tester);

      // Should start on welcome screen
      await completeWelcomeScreen(tester);

      // Now we should be on language screen
      await completeLanguageScreenWithLanguage(tester, "en");

      // Now we should be on pre-intro screen
      await completeIntroBySkipping(tester);

      // Now we should be on tos screen
      await completeTosByAccepting(tester);

      // Now we should be pre user creator
      await completeUserCreationBySkipping(tester);

      // We should end up at home
      expect(find.byType(HomeScreen), findsOne);
    });

    testWidgets("scenario: take expert intro", (tester) async {
      await openApp(tester);

      // Should start on welcome screen
      await completeWelcomeScreen(tester);

      // Now we should be on language screen
      await completeLanguageScreenWithLanguage(tester, "en");

      // Now we take the intro
      await completeExpertIntro(tester);

      // Now we should be on tos screen
      await completeTosByAccepting(tester);

      // Now we should be pre user creator
      await completeUserCreationBySkipping(tester);

      // We should end up at home
      expect(find.byType(HomeScreen), findsOne);
    });

    testWidgets("scenario: take non-expert intro", (tester) async {
      await openApp(tester);

      // Should start on welcome screen
      await completeWelcomeScreen(tester);

      // Now we should be on language screen
      await completeLanguageScreenWithLanguage(tester, "en");

      // Now we take the intro
      await completeNonExpertIntro(tester);

      // Now we should be on tos screen
      await completeTosByAccepting(tester);

      // Now we should be pre user creator
      await completeUserCreationBySkipping(tester);

      // We should end up at home
      expect(find.byType(HomeScreen), findsOne);
    });

    testWidgets("scenario: create user", (tester) async {
      await openApp(tester);

      await completeWelcomeScreen(tester);

      await completeLanguageScreenWithLanguage(tester, "en");

      await completeIntroBySkipping(tester);

      await completeTosByAccepting(tester);

      await completeUserCreatorWith(tester, "Cool user", "m");

      // We should end up at home
      expect(find.byType(HomeScreen), findsOne);

      // The entered nick name should be displayed
      expect(find.textContaining("Cool user"), findsOne);
    });

    testWidgets("scenario: onboarding is skipped when a user exists",
        (tester) async {
      await clearAppStorage();

      await addUser(User(name: "Cool user", hasSeenTutorial: true));

      await openApp(tester);

      await completeWelcomeScreen(tester);

      expect(find.byType(HomeScreen), findsOne);
    });
  });
}
