import 'package:ergo4all/common/intro.dart';
import 'package:ergo4all/language/screen.dart';
import 'package:ergo4all/onboarding/pre_intro_screen.dart';
import 'package:ergo4all/onboarding/pre_user_creator_screen.dart';
import 'package:ergo4all/onboarding/user_creator_screen.dart';
import 'package:ergo4all/terms_of_use/screen.dart';
import 'package:ergo4all/welcome/screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> completeWelcomeScreen(WidgetTester tester) async {
  // Should be on welcome screen
  expect(find.byType(WelcomeScreen), findsOne);

  // Wait a moment for the screen to get ready
  await tester.pump(const Duration(milliseconds: 500));

  // Press start
  await tester.tap(find.byKey(const Key('start')));
  await tester.pumpAndSettle();
}

Future<void> completeLanguageScreenWithLanguage(
  WidgetTester tester,
  String languageName,
) async {
  // We should be on language screen
  expect(find.byType(PickLanguageScreen), findsOne);

  // Pick english
  await tester.tap(find.byKey(Key('lang_button_$languageName')));
  await tester.pumpAndSettle();
}

Future<void> completeIntroBySkipping(WidgetTester tester) async {
  // We should be on pre-intro screen
  expect(find.byType(PreIntroScreen), findsOne);

  // Skip intro
  await tester.tap(find.byKey(const Key('skip')));
  await tester.pumpAndSettle();
}

Future<void> completeIntro(WidgetTester tester) async {
  // We should be on intro screen
  expect(find.byType(Intro), findsOne);

  // Swipe right a few times
  for (var i = 0; i < 5; i++) {
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
  }

  // We are done
  await tester.tap(find.byKey(const Key('done')));
  await tester.pumpAndSettle();
}

Future<void> completeExpertIntro(WidgetTester tester) async {
  // We should be on pre-intro screen
  expect(find.byType(PreIntroScreen), findsOne);

  // Start expert intro
  await tester.tap(find.byKey(const Key('expert')));
  await tester.pumpAndSettle();

  await completeIntro(tester);
}

Future<void> completeNonExpertIntro(WidgetTester tester) async {
  // We should be on pre-intro screen
  expect(find.byType(PreIntroScreen), findsOne);

  // Start non-expert intro
  await tester.tap(find.byKey(const Key('non-expert')));
  await tester.pumpAndSettle();

  await completeIntro(tester);
}

Future<void> completeTosByAccepting(WidgetTester tester) async {
  // We should be on tos screen
  expect(find.byType(TermsOfUseScreen), findsOne);

  // We accept and move on
  await tester.tap(find.byKey(const Key('accept-check')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('next')));
  await tester.pumpAndSettle();
}

Future<void> completeUserCreationBySkipping(WidgetTester tester) async {
  // We should be pre user creator
  expect(find.byType(PreUserCreatorScreen), findsOne);

  // We use default values and move on
  await tester.tap(find.byKey(const Key('default-values')));
  await tester.pumpAndSettle();
}

Future<void> completeUserCreatorWith(
  WidgetTester tester,
  String nickName,
  String sex,
) async {
  // We should be pre user creator
  expect(find.byType(PreUserCreatorScreen), findsOne);

  // We continue to the user creation screen
  await tester.tap(find.byKey(const Key('create')));
  await tester.pumpAndSettle();

  // Should now be on user creation screen
  expect(find.byType(UserCreatorScreen), findsOne);

  // Enter nick name
  await tester.enterText(find.byKey(const Key('nickNameInput')), nickName);
  await tester.pumpAndSettle();

  // Enter sex
  await tester.enterText(find.byKey(const Key('sexInput')), sex);
  await tester.pumpAndSettle();

  // Submit
  await tester.scrollUntilVisible(
    find.byKey(const Key('create')),
    10,
    scrollable: find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(Scrollable).at(0),
    ),
  );
  await tester.tap(find.byKey(const Key('create')));
  await tester.pumpAndSettle();
}

Future<void> completeOnboardingWithDefaultUser(WidgetTester tester) async {
  await completeWelcomeScreen(tester);

  // Now we should be on language screen
  await completeLanguageScreenWithLanguage(tester, 'en');

  // Now we should be on pre-intro screen
  await completeIntroBySkipping(tester);

  // Now we should be on tos screen
  await completeTosByAccepting(tester);

  // Now we should be pre user creator
  await completeUserCreationBySkipping(tester);
}
