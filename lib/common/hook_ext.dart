import 'package:flutter/foundation.dart';

extension DeconstructExt<T> on ValueNotifier<T> {
  /// Splits a [ValueNotifier] into a tuple containing its value and a mutation function, similarly to how it is done in react.
  ///
  /// You may then use it like `final (value, setValue) = myValueNotifier.split();`
  (T value, void Function(T newValue) setValue) split() {
    return (
      value,
      (newValue) {
        value = newValue;
      }
    );
  }
}
