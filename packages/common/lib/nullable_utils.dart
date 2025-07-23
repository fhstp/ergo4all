/// Makes the function [f] null-friendly, by making both its input and output
/// nullable. If the input is null, the function returns null.
TOut? Function(TIn?) doMaybe<TIn extends Object, TOut>(TOut? Function(TIn) f) {
  return (input) => input != null ? f(input) : null;
}

/// Utility extensions for working with nullable objects.
extension NullUtils<T> on T? {
  /// Gets the non-null value or asserts with [msg] if value is `null`.
  T expect(String msg) {
    assert(this != null, msg);
    return this!;
  }
}
