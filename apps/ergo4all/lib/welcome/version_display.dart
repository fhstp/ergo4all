import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

/// Displays the apps version if it is known.
class VersionDisplay extends StatelessWidget {
  ///
  const VersionDisplay({required this.version, this.onTap, super.key});

  /// The apps version if known. Should be a semantic version, such as 1.0.3.
  final Option<String> version;

  /// Callback for when the versions is tapped.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(version.match(() => '...', (it) => 'v$it')),
    );
  }
}
