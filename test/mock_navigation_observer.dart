import 'package:flutter/material.dart';

typedef NavigateCallback = void Function(Route? route, Route? previousRoute);

class MockNavigationObserver extends NavigatorObserver {
  NavigateCallback? pushed;
  NavigateCallback? popped;
  NavigateCallback? removed;
  NavigateCallback? replaced;

  MockNavigationObserver(
      {this.pushed, this.popped, this.removed, this.replaced});

  @override
  void didPush(Route route, Route? previousRoute) {
    pushed?.call(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    popped?.call(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    removed?.call(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    replaced?.call(newRoute, oldRoute);
  }
}
