import 'package:flutter/material.dart';

/// Navigation observer which notifies when navigating away from a given route.
class RouteLeaveObserver extends NavigatorObserver {
  RouteLeaveObserver({required this.routeName, required this.onLeft});

  final String routeName;
  final void Function() onLeft;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute?.settings.name == routeName) {
      onLeft();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute?.settings.name == routeName) {
      onLeft();
    }
  }
}
