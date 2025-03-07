import 'package:common_ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmering box which can be displayed instead of rectangular content while it loads.
class ShimmerBox extends StatelessWidget {
  /// The width of the box.
  final double width;

  /// The height of the box.
  final double height;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(smallSpace),
            child: Container(
              width: width,
              height: height,
              color: Colors.white,
            )));
  }
}
