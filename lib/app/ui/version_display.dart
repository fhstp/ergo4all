import 'package:flutter/material.dart';

class VersionDisplay extends StatelessWidget {
  final String? version;

  const VersionDisplay({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Text(version != null ? "v$version" : "...");
  }
}
