import 'package:common_ui/theme/colors.dart';
import 'package:flutter/material.dart';

/// Custom [IconButton] for navigating backwards. This is a replacement to
/// the built-in material [BackButton].
class IconBackButton extends StatelessWidget {
  ///
  const IconBackButton({
    this.color = woodSmoke,
    super.key,
  });

  /// The color to use for the icon
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new, color: color),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}
