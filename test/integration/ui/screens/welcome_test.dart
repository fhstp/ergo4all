import 'dart:async';

import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/ui/screens/welcome.dart';
import 'package:ergo4all/service/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../app_mock.dart';

void main() {
  testWidgets("should load custom locale", (tester) async {
    final completer = Completer();

    GetIt.instance.registerSingleton<GetCurrentUser>(() async => null);
    final mockCustomLocale = CustomLocale(() async {
      completer.complete();
      return null;
    }, (_) async {});

    await tester.pumpWidget(makeMockAppFromWidget(const WelcomeScreen(), null,
        [ChangeNotifierProvider(create: (_) => mockCustomLocale)]));

    expect(completer.isCompleted, isTrue);
  });
}
