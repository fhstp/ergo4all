import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';

/// Utilities for [IMap].
extension IMapExt<Key, Value> on IMap<Key, Value> {
  /// Maps the entries in this [IMap] by applying [f] to all values, but
  /// keeping the keys unchanged.
  IMap<Key, Mapped> mapValues<Mapped>(Mapped Function(Value value) f) =>
      map((key, value) => MapEntry(key, f(value)));
}

/// Utilities for 2d [IList].
extension IList2dExt<T> on IList<IList<T>> {
  /// Iterates the columns in a 2d list
  ///
  /// ```dart
  /// final list2d = IList([
  ///   [1, 8, 6],
  ///   [4, 2, 9],
  ///   [7, 5, 3]
  /// ])
  ///
  /// // [
  /// //  [1, 4, 7],
  /// //  [8, 2, 5],
  /// //  [6, 9, 3]
  /// // ]
  /// final columns = list2d.columns()
  /// ```
  Iterable<IList<T>> columns() {
    if (isEmpty) return const Iterable.empty();

    final columnCount = get(0).length;

    final rowsHaveSameLength = all((items) => items.length == columnCount);
    assert(rowsHaveSameLength, 'All rows must have same length');

    return Iterable.generate(columnCount, (i) {
      return map((items) => items[i]).toIList();
    });
  }

  /// Reduces a 2d [IList] by applying [reduce] to each 'column'.
  ///
  /// ```dart
  /// final list2d = IList([
  ///   [1, 8, 6],
  ///   [4, 2, 9],
  ///   [7, 5, 3]
  /// ])
  ///
  /// final reduced = list2d.reduce2d(max) // [1, 2, 3]
  /// ```
  IList<T> reduce2d(T Function(T item1, T item2) reduce) =>
      columns().map((items) => items.reduce(reduce)).toIList();
}
