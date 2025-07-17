import 'package:ergo4all/common/rula_color.dart';
import 'package:flutter/material.dart';

/// A graphic displaying a full ergo-puppet inside a circle with a drop-shadow.
class PuppetGraphic extends StatelessWidget {
  ///
  const PuppetGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 309,
      height: 309,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Image.asset(
            'assets/images/puppet/full_body.png',
            color: RulaColor.forScore(0),
            fit: BoxFit.contain,
            colorBlendMode: BlendMode.modulate,
          ),
        ),
      ),
    );
  }
}
