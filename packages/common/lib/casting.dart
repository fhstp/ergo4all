/// Extensions for casting types.
extension AsExtension on Object? {
  /// Alternative to the `as` operator.
  X as<X>() => this as X;

  /// Safe version of the `as` operator. Returns `null` if the cast is not
  /// possible.
  X? tryAs<X>() {
    final self = this;
    return self is X ? self : null;
  }
}
