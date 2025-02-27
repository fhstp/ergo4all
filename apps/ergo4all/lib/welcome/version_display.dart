import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class VersionDisplay extends StatelessWidget {
  final Option<String> version;

  const VersionDisplay({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Text(version.match(() => "...", (it) => "v$it"));
  }
}
