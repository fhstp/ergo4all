import 'package:flutter/material.dart';

/// Widget for painting on top of another widget using a [CustomPainter].
/// The painter will be scaled to fit the base widget.
class PaintOnWidget extends StatelessWidget {
  /// Constructs a [PaintOnWidget].
  const PaintOnWidget({
    required this.base,
    super.key,
    this.painter,
  });

  /// The widget to paint onto.
  final Widget base;

  /// The painter to use for painting. Will not do any painting if [Null].
  final CustomPainter? painter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        base,
        if (painter != null)
          Positioned.fill(child: CustomPaint(painter: painter)),
      ],
    );
  }
}
