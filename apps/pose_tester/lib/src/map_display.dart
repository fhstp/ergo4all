import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class MapDisplay<TKey, TValue> extends StatelessWidget {
  final String Function(TKey) formatKey;
  final String Function(TValue) formatValue;

  final IMap<TKey, TValue> map;

  const MapDisplay(
      {super.key,
      required this.map,
      required this.formatKey,
      required this.formatValue});

  @override
  Widget build(BuildContext context) {
    Widget displayFor(TKey key, TValue value) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${formatKey(key)}: ${formatValue(value)}"),
        ),
      );
    }

    return Wrap(
      children: map.mapTo(displayFor).toList(),
    );
  }
}
