import 'package:flutter/material.dart';

typedef NavigateCallback = void Function(Route? route, Route? previousRoute);

class MockNavigationObserver extends NavigatorObserver {
  bool _anyNavigationHappened = false;

  final NavigateCallback? _pushed;
  final NavigateCallback? _popped;
  final NavigateCallback? _removed;
  final NavigateCallback? _replaced;

  bool get anyNavigationHappened => _anyNavigationHappened;

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
    if (previousRoute != null) _anyNavigationHappened = true;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _popped?.call(route, previousRoute);
    if (previousRoute != null) _anyNavigationHappened = true;
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _removed?.call(route, previousRoute);
    if (previousRoute != null) _anyNavigationHappened = true;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _replaced?.call(newRoute, oldRoute);
    if (oldRoute != null) _anyNavigationHappened = true;
  }
}
