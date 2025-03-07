import 'package:flutter/material.dart';

/// A small circular progress indicator.
class ProgressIndicator extends StatelessWidget {
  /// Creates a progress indicator.
  const ProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
