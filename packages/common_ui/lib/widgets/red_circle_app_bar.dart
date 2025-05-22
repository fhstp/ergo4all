import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const double _appBarHeight = 200;

/// The red circle element at the top of a lot of pages. See the
/// [Figma design for the Home screen](https://www.figma.com/design/ToLbPoKLTVnyU33ItvwLuH/Ergo4All-draft-for-new-design?node-id=123-520&t=Xp1FzTpSjlknOlQY-4)
/// for an example.
///
/// You can use it for [Scaffold#appBar].
class RedCircleAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Construct a circle bar.
  const RedCircleAppBar({
    required this.titleText,
    this.withBackButton = false,
    this.menuButton,
    super.key,
  });

  /// The title text displayed on the circle.
  final String titleText;

  /// Whether to include a back-button in the bar.
  final bool withBackButton;

  /// An optional (pressable) widget which is displayed on the top right of the
  /// bar.
  final Widget? menuButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _appBarHeight,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SvgPicture.asset(
            fit: BoxFit.fill,
            package: 'common_ui',
            'assets/images/top_circle.svg',
          ),
          if (withBackButton)
            Positioned(
              top: 50,
              left: mediumSpace,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: white),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
            ),
          if (menuButton != null)
            Positioned(
              top: 50,
              right: mediumSpace,
              child: menuButton!,
            ),
          Positioned(
            top: 100,
            child: Text(
              titleText,
              style: h1Style.copyWith(color: white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_appBarHeight);
}
