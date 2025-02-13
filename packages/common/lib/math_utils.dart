/// Inversely interpolates [a] to [b] using [c] and returns the resulting t.
double invLerp(double a, double b, double c) {
  return (c - a) / (b - a);
}
