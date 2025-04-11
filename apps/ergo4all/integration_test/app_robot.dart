import 'package:ergo4all/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_management/user_management.dart';

Future<void> clearAppStorage() async {
  await clearAllUserData();
}

Future<void> openApp(WidgetTester tester) async {
  await tester.pumpWidget(const Ergo4AllApp());
}
