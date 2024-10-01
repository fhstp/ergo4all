import 'package:flutter/material.dart';

/// Contains custom image assets for use in an [Image] widget.
abstract final class CustomImages {
  /// The app icon in solid white color.
  static const iconWhite = AssetImage('assets/images/logos/IconWhite.png');

  /// The app icon in solid red color.
  static const iconRed = AssetImage('assets/images/logos/IconRed.png');

  /// The app logo (icon + text) in solid red color.
  static const logoRed = AssetImage('assets/images/logos/LogoRed.png');
}
