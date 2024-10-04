import 'package:flutter_exit_app/flutter_exit_app.dart';

/// Function interface for a function which exits the app.
typedef ExitApp = Future<Null> Function();

/// Implementation of [ExitApp] which uses the [flutter_exit_app] package.
// ignore: prefer_function_declarations_over_variables
final ExitApp multiPlatformExitApp = () async {
  await FlutterExitApp.exitApp();
};
