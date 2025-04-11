import 'package:flutter/material.dart';

class ScreenContent extends StatelessWidget {
  const ScreenContent({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.15;
    return Padding(
      padding: EdgeInsets.only(top: padding, right: padding, left: padding),
      child: Center(child: child),
    );
  }
}
