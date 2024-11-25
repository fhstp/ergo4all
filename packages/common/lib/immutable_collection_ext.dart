import 'package:fast_immutable_collections/fast_immutable_collections.dart';

extension IMapExt<Key, Value> on IMap<Key, Value> {
  /// Maps the entries in this [IMap] by applying [f] to all values, but keeping the keys unchanged.
  IMap<Key, Mapped> mapValues<Mapped>(Mapped Function(Value value) f) =>
      map((key, value) => MapEntry(key, f(value)));
}
