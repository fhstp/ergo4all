import 'package:flutter/foundation.dart';

extension UtilExt<T> on ValueNotifier<T> {
  /// Updates this notifiers value by applying [f] to it.
  void update(T Function(T) f) {
    value = f(value);
  }
}
