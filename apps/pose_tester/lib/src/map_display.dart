import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class MapDisplay<TKey, TValue> extends StatelessWidget {
  const MapDisplay({
    required this.map,
    required this.formatKey,
    required this.formatValue,
    super.key,
  });

  final String Function(TKey) formatKey;
  final String Function(TValue) formatValue;

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
