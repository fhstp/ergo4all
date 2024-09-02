import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1,
      child: Stack(children: [
        Center(
          child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child:
                  Image(image: AssetImage('assets/images/logos/IconRed.png'))),
        ),
        SizedBox.expand(child: CircularProgressIndicator())
      ]),
    );
  }
}
