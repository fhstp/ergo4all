import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// Contains 2 element pair utility functions.
abstract final class Pair {
  /// Creates a function which applies the given function [f] to both elements
  /// in a pair.
  static (U, U) Function((T, T)) map<T, U>(U Function(T) f) {
    return (pair) => (f(Pair.left(pair)), f(Pair.right(pair)));
  }

  /// Selects the first/left element of a pair.
  static T left<T>((T, T) pair) {
    return pair.$1;
  }

  /// Selects the second/right element of a pair.
  static T right<T>((T, T) pair) {
    return pair.$2;
  }

  /// Reduces the two values in the pair into a single function using the given
  /// function [f].
  static U Function((T, T)) reduce<T, U>(U Function(T, T) f) {
    return (pair) => f(left(pair), right(pair));
  }

  /// Constructs a pair by repeating the given [value] twice.
  static (T, T) of<T>(T value) => (value, value);

  /// Checks whether both values in a pair match the given [predicate].
  static bool Function((T, T)) all<T>(bool Function(T) predicate) =>
      (pair) => predicate(left(pair)) && predicate(right(pair));

  /// Promotes a binary function [f] to work on pairs of it's inputs.
  static (V, V) Function((T, T), (U, U)) pairwise<T, U, V>(V Function(T, U) f) {
    return (t, u) =>
        (f(Pair.left(t), Pair.left(u)), f(Pair.right(t), Pair.right(u)));
  }

  /// Converts this pair into a 2-item [IList].
  static IList<T> toList<T>((T, T) pair) => IList([left(pair), right(pair)]);
}
