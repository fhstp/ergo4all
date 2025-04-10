import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// The red circle element at the top of a lot of pages. See the
/// [Figma design for the Home screen](https://www.figma.com/design/ToLbPoKLTVnyU33ItvwLuH/Ergo4All-draft-for-new-design?node-id=123-520&t=Xp1FzTpSjlknOlQY-4)
/// for an example.
class RedCircleTopBar extends StatelessWidget {
  /// Construct a circle bar.
  const RedCircleTopBar({
    required this.titleText,
    super.key,
  });

  /// The title text displayed on the circle.
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SvgPicture.asset(
            'assets/images/top_circle.svg',
            package: 'common_ui',
          ),
        ),
        Positioned(
          top: 80,
          child: Text(
            titleText,
            style: h1Style.copyWith(color: white),
          ),
        ),
      ],
    );
  }
}
