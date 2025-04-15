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
    this.menuButton,
    super.key,
  });

  /// The title text displayed on the circle.
  final String titleText;

  /// An optional (pressable) widget which is displayed on the top right of the
  /// bar.
  final Widget? menuButton;

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
        if (menuButton != null)
          Positioned(top: 70, right: 40, child: menuButton!),
        Positioned(
          top: 120,
          child: Text(
            titleText,
            style: h1Style.copyWith(color: white),
          ),
        ),
      ],
    );
  }
}
