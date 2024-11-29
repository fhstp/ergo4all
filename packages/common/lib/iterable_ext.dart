/// Useful extensions for iterables.
extension UtilExt<T> on Iterable<T> {
  /// Average a collection of items by providing a function [sumF] to add two items and then [divideF] to divide the resulting sum by the number of items.
  T averageUsing(T Function(T, T) sumF, T Function(T, int) divideF) {
    var list = toList();
    final sum = list.reduce(sumF);
    return divideF(sum, list.length);
  }
}
