import 'package:flutter/material.dart';

typedef NavigateCallback = void Function(Route? route, Route? previousRoute);

class MockNavigationObserver extends NavigatorObserver {
  final NavigateCallback? _pushed;
  final NavigateCallback? _popped;
  final NavigateCallback? _removed;
  final NavigateCallback? _replaced;

  MockNavigationObserver(
      {NavigateCallback? pushed,
      NavigateCallback? popped,
      NavigateCallback? removed,
      NavigateCallback? replaced})
      : _replaced = replaced,
        _removed = removed,
        _popped = popped,
        _pushed = pushed;

  @override
  void didPush(Route route, Route? previousRoute) {
    _pushed?.call(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _popped?.call(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _removed?.call(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _replaced?.call(newRoute, oldRoute);
  }
}
