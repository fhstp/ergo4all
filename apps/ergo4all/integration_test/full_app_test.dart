import 'package:ergo4all/app.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/language/screen.dart';
import 'package:ergo4all/results/results_detail_screen.dart';
import 'package:ergo4all/scenario/scenario_choice_screen.dart';
import 'package:ergo4all/scenario/scenario_detail_screen.dart';
import 'package:ergo4all/welcome/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_management/user_management.dart';

Future<void> clearAppStorage() async {
  await clearAllUserData();
}

void expectScreen(Type screenType) {
  expect(find.byType(screenType), findsOneWidget);
}

Future<void> pumpContinuously(
  PatrolIntegrationTester tester,
  Duration duration, [
  Duration interval = const Duration(milliseconds: 16),
]) async {
  var elapsed = Duration.zero;
  while (elapsed < duration) {
    await tester.pump(interval);
    elapsed += interval;
  }
}

void main() {
  patrolTest('full app play-through', (tester) async {
    // Open the app
    await clearAppStorage();
    await tester.pumpWidget(const Ergo4AllApp());

    // We should be on welcome screen
    expectScreen(WelcomeScreen);

    // The user looks at the screen for a bit and then we move on
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('start')));
    await tester.pumpAndSettle();

    // We should now be on the language choose screen and pick english
    expectScreen(PickLanguageScreen);
    await tester.tap(find.byKey(const Key('lang_button_en')));

    // We should now be on the home screen
    expectScreen(HomeScreen);

    // The user looks at the screen for a bit and then we they want to
    // record a video
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('start')));
    await tester.pumpAndSettle();

    // Now its time to pick a scenario
    expectScreen(ScenarioChoiceScreen);

    // The user first wants to do some seated work
    await tester.tap(find.byKey(const Key('scenario_button_seated')));
    await tester.pumpAndSettle();

    // Let's look at the scenario in detail
    expectScreen(ScenarioDetailScreen);

    // The user looks at the text and then we start recording
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('start')));
    await tester.pumpAndSettle();

    // We are now on the camera screen and need to grant camera permissions
    if (await tester.native.isPermissionDialogVisible()) {
      await tester.native.grantPermissionWhenInUse();
    }

    // The user looks at the screen a while before starting the recording
    await pumpContinuously(tester, const Duration(seconds: 2));
    await tester.tap(
      find.byKey(const Key('record')),
      settlePolicy: SettlePolicy.noSettle,
    );

    // Afterwards they record for a few seconds
    await pumpContinuously(tester, const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('record')));

    // We are now on the result screen where the user looks around a bit
    expectScreen(ResultsDetailScreen);
    await tester.pump(const Duration(seconds: 1));

    // They want to know more about a body part so they navigate to the
    // detail screen for that and look around a bit, before going back
    await tester.tap(find.byKey(const Key('heatmap')));
    await tester.pump(const Duration(seconds: 1));
    await tester.native.pressBack();
    await tester.pumpAndSettle();

    // We should now be back at the overview. The user is done here, so they
    // go back once more
    expectScreen(ResultsDetailScreen);
    await tester.native.pressBack();
    await tester.pumpAndSettle();

    // We should end up on the home screen
    expectScreen(HomeScreen);

    // The user now realizes that they would understand the tips better if
    // they were in german. They search the option in the burger menu
    await tester.tap(find.byKey(const Key('burger')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('button-lang')));

    // We are on the language screen again and this time we pick german
    expectScreen(PickLanguageScreen);
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('lang_button_de')));

    // Now we should be home again
    expectScreen(HomeScreen);
    await tester.pump(const Duration(seconds: 1));

    // The user now wants to look at some tips
    await tester.tap(find.byKey(const Key('tips')));
    await tester.pump(const Duration(seconds: 1));

    // TODO: Add more tips tests here
    // For now we just go pack
    await tester.native.pressBack();
    await tester.pumpAndSettle();

    // Let's record another video
    await tester.tap(find.byKey(const Key('start')));
    expectScreen(ScenarioChoiceScreen);
    await tester.tap(find.byKey(const Key('scenario_button_ceiling')));
    await tester.pumpAndSettle();
    expectScreen(ScenarioDetailScreen);
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const Key('start')));
    await pumpContinuously(tester, const Duration(seconds: 1));
    await tester.tap(
      find.byKey(const Key('record')),
      settlePolicy: SettlePolicy.noSettle,
    );
    await pumpContinuously(tester, const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('record')));
    await tester.native.pressBack();
    await tester.pumpAndSettle();

    // We should end one home
    expectScreen(HomeScreen);

    // Lets close the app
    await tester.native.pressBack();
    await tester.pumpAndSettle();
  });
}
