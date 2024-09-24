extension ListExtensions<E> on List<E> {
  /// Immutably updates an element at the given [index] by applying [mapF] to
  /// it. Returns the updated list.
  List<E> mapAt(int index, E Function(E) mapF) {
    return List<E>.from(this)..[index] = mapF(this[index]);
  }
}
