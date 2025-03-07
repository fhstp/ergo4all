import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Displays the key-value pairs in a [Map].
class MapDisplay<TKey, TValue> extends StatelessWidget {
  /// Creates a [MapDisplay].
  const MapDisplay({
    required this.map,
    required this.formatKey,
    required this.formatValue,
    super.key,
  });

  /// A selector for converting a key to a displayed [String].
  final String Function(TKey) formatKey;

  /// A selector for converting a value to a displayed [String].
  final String Function(TValue) formatValue;

  /// The map to display.
  final IMap<TKey, TValue> map;

  @override
  Widget build(BuildContext context) {
    Widget displayFor(TKey key, TValue value) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text('${formatKey(key)}: ${formatValue(value)}'),
        ),
      );
    }

    return Wrap(
      children: map.mapTo(displayFor).toList(),
    );
  }
}
