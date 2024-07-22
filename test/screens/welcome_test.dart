import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/screens/welcome.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../mock_app.dart';

void main() {
  testWidgets("should load custom locale", (tester) async {
    var wasLoaded = false;

    final mockCustomLocale = CustomLocale(() async {
      wasLoaded = true;
      return null;
    }, (_) async {});

    await tester.pumpWidget(makeMockAppFromWidget(const WelcomeScreen(), null,
        [ChangeNotifierProvider(create: (_) => mockCustomLocale)]));

    expect(wasLoaded, isTrue);
  });
}
