/// Inversely interpolates [a] to [b] using [c] and returns the resulting t.
double invLerp(double a, double b, double c) {
  return (c - a) / (b - a);
}

/// Contains functional versions of common math operations for easier use in
/// pipes.
abstract final class Math {
  /// Add two numbers.
  static T add<T extends num>(T a, T b) => (a + b) as T;
}
