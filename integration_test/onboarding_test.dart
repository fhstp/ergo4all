import 'package:ergo4all/app.dart';
import 'package:ergo4all/common/intro.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/pick_language/screen.dart';
import 'package:ergo4all/pre_intro_screen.dart';
import 'package:ergo4all/pre_user_creator_screen.dart';
import 'package:ergo4all/terms_of_use_screen.dart';
import 'package:ergo4all/welcome/screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> cleanAppOpen(WidgetTester tester) async {
    await tester.pumpWidget(Ergo4AllApp());
  }

  Future<void> completeWelcomeScreen(WidgetTester tester) async {
    // Should be on welcome screen
    expect(find.byType(WelcomeScreen), findsOne);

    // Wait for welcome screen to pass
    await tester.pumpAndSettle();
  }

  Future<void> completeLanguageScreenWithLanguage(
      WidgetTester tester, String languageName) async {
    // We should be on language screen
    expect(find.byType(PickLanguageScreen), findsOne);

    // Pick english
    await tester.tap(find.byKey(Key("lang_button_$languageName")));
    await tester.pumpAndSettle();
  }

  Future<void> completeIntroBySkipping(WidgetTester tester) async {
    // We should be on pre-intro screen
    expect(find.byType(PreIntroScreen), findsOne);

    // Skip intro
    await tester.tap(find.byKey(Key("skip")));
    await tester.pumpAndSettle();
  }

  Future<void> completeIntro(WidgetTester tester) async {
    // We should be on intro screen
    expect(find.byType(Intro), findsOne);

    // Swipe right a few times
    for (var i = 0; i < 5; i++) {
      await tester.drag(find.byType(PageView), Offset(-400, 0));
      await tester.pumpAndSettle();
    }

    // We are done
    await tester.tap(find.byKey(Key("done")));
    await tester.pumpAndSettle();
  }

  Future<void> completeExpertIntro(WidgetTester tester) async {
    // We should be on pre-intro screen
    expect(find.byType(PreIntroScreen), findsOne);

    // Start expert intro
    await tester.tap(find.byKey(Key("expert")));
    await tester.pumpAndSettle();

    await completeIntro(tester);
  }

  Future<void> completeNonExpertIntro(WidgetTester tester) async {
    // We should be on pre-intro screen
    expect(find.byType(PreIntroScreen), findsOne);

    // Start non-expert intro
    await tester.tap(find.byKey(Key("non-expert")));
    await tester.pumpAndSettle();

    await completeIntro(tester);
  }

  Future<void> completeTosByAccepting(WidgetTester tester) async {
    // We should be on tos screen
    expect(find.byType(TermsOfUseScreen), findsOne);

    // We accept and move on
    await tester.tap(find.byKey(Key("accept-check")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("next")));
    await tester.pumpAndSettle();
  }

  Future<void> completeUserCreationBySkipping(WidgetTester tester) async {
    // We should be pre user creator
    expect(find.byType(PreUserCreatorScreen), findsOne);

    // We use default values and move on
    await tester.tap(find.byKey(Key("default-values")));
    await tester.pumpAndSettle();
  }

  testWidgets("scenario: skip past everything", (tester) async {
    await cleanAppOpen(tester);

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
    await cleanAppOpen(tester);

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
    await cleanAppOpen(tester);

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
}
