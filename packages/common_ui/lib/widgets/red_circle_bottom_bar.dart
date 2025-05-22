import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// The red circle element at the bottom of a lot of pages. See the
/// [Figma design for the Home screen](https://www.figma.com/design/ToLbPoKLTVnyU33ItvwLuH/Ergo4All-draft-for-new-design?node-id=123-520&t=Xp1FzTpSjlknOlQY-4)
/// for an example.
///
/// You can use it for [Scaffold#appBar].
class RedCircleBottomBar extends StatelessWidget{
  /// Construct a circle bar.
  const RedCircleBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          SvgPicture.asset(
            fit: BoxFit.fill,
            package: 'common_ui',
            'assets/images/bottom_circle.svg',
          ),
        ],
      ),
    );
  }
}
