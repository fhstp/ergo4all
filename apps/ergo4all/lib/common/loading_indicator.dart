import 'package:ergo4all/common/custom_images.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Image(image: CustomImages.iconRed),
            ),
          ),
          SizedBox.expand(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
