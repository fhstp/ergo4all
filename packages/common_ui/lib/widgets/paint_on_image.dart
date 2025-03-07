import 'package:flutter/material.dart';

class PaintOnWidget extends StatelessWidget {
  const PaintOnWidget({
    required this.base,
    super.key,
    this.painter,
  });

  final Widget base;
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
