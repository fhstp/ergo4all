import 'package:fpdart/fpdart.dart';

/// Useful extensions for iterables.
extension UtilExt<T> on Iterable<T> {
  /// Average a collection of items by providing a function [sumF] to add two
  /// items and then [divideF] to divide the resulting sum by the number
  /// of items.
  T averageUsing(T Function(T, T) sumF, T Function(T, int) divideF) {
    final list = toList();
    final sum = list.reduce(sumF);
    return divideF(sum, list.length);
  }

  /// Applies the mapping function [f] to each element in the iterable
  /// and returns only elements for which it returned [Some].
  Iterable<U> filterMap<U>(Option<U> Function(T) f) sync* {
    for (final item in this) {
      if (f(item) case Some(:final value)) yield value;
    }
  }

  /// Calculates the mode of a series of items, ie. the item which came
  /// up the most often. If multiple items have the same count then
  /// one of them is picked in an undefined behavior.
  T? mode() {
    final counts = <T, int>{};

    for (final item in this) {
      counts[item] = (counts[item] ?? 0) + 1;
    }

    return counts.entries
        .sortWith((e) => e.value, Order.orderInt.reverse)
        .firstOrNull
        ?.key;
  }
}
