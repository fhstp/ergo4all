import 'package:ergo4all/app/routes.dart';
import 'package:flutter/material.dart';

/// Navigation observer which notifies when navigating away from the
/// [Routes.language] route.
class PostLanguageNavObserver extends NavigatorObserver {
  final void Function() onNavigatedAwayFromLanguage;

  PostLanguageNavObserver(this.onNavigatedAwayFromLanguage);

  @override
  void didPush(Route route, Route? previousRoute) {
    if (previousRoute?.settings.name == Routes.language.path) {
      onNavigatedAwayFromLanguage();
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute?.settings.name == Routes.language.path) {
      onNavigatedAwayFromLanguage();
    }
  }
}
