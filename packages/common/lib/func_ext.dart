import 'package:fpdart/fpdart.dart';

/// Extensions for value piping.
extension PipeExt<T> on T {
  /// Pipe this value through the given function [f], allowing for
  /// in-place method chaining.
  U pipe<U>(U Function(T) f) {
    return f(this);
  }
}

/// Extensions for function composition
extension ComposeExt<T, U> on U Function(T) {
  /// Composes this function with [f].
  V Function(T) compose<V>(V Function(U) f) {
    return (t) => f(this(t));
  }
}

/// Utility extensions for [Option].
extension OptionExt<T> on Option<T> {
  /// Gets the value from this option or asserts with [message].
  /// Inspired by the [Rust function of the same name](https://doc.rust-lang.org/std/option/enum.Option.html#method.expect).
  T expect(String message) {
    assert(isSome(), message);
    return getOrElse(() {
      throw Error();
    });
  }
}
