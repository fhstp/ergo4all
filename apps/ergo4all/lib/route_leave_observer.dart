import 'package:flutter/material.dart';

/// Navigation observer which notifies when navigating away from a given route.
class RouteLeaveObserver extends NavigatorObserver {
  final String routeName;
  final void Function() onLeft;

  RouteLeaveObserver({required this.routeName, required this.onLeft});

  @override
  void didPush(Route route, Route? previousRoute) {
    if (previousRoute?.settings.name == routeName) {
      onLeft();
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute?.settings.name == routeName) {
      onLeft();
    }
  }
}
