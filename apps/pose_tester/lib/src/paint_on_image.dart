// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class PaintOnWidget extends StatelessWidget {
  final Widget base;
  final CustomPainter? painter;

  const PaintOnWidget({
    super.key,
    required this.base,
    this.painter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        base,
        if (painter != null)
          Positioned.fill(child: CustomPaint(painter: painter))
      ],
    );
  }
}
