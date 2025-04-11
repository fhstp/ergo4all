import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class VersionDisplay extends StatelessWidget {
  const VersionDisplay({required this.version, super.key});
  final Option<String> version;

  @override
  Widget build(BuildContext context) {
    return Text(version.match(() => '...', (it) => 'v$it'));
  }
}
