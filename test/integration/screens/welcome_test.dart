import 'dart:async';

import 'package:ergo4all/app/custom_locale.dart';
import 'package:ergo4all/app/screens/welcome.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../app_mock.dart';

void main() {
  testWidgets("should load custom locale", (tester) async {
    final completer = Completer();

    final mockCustomLocale = CustomLocale(() async {
      completer.complete();
      return null;
    }, (_) async {});

    await tester.pumpWidget(makeMockAppFromWidget(WelcomeScreen(
      getCurrentUser: () async {
        return null;
      },
    ), null, [ChangeNotifierProvider(create: (_) => mockCustomLocale)]));

    expect(completer.isCompleted, isTrue);
  });
}
