import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';

/// Contains custom image assets for use in an [Image] widget.
abstract final class CustomImages {
  /// The app icon in solid white color.
  static const iconWhite = AssetImage('assets/images/logos/IconWhite.png');

  /// The app icon in solid red color.
  static const iconRed = AssetImage('assets/images/logos/IconRed.png');

  /// The app logo (icon + text) in solid red color.
  static const logoRed = SvgAssetLoader('assets/images/logos/logo_red.svg');

  /// The app logo (icon + text) in solid white color.
  static const logoWhite = SvgAssetLoader('assets/images/logos/logo_white.svg');

  /// The logo for AK Niederösterreich
  static const logoAk = AssetImage('assets/images/logos/ak.jpg');

  /// The logo for TU Wien
  static const logoTUWien = AssetImage('assets/images/logos/tuwien.jpg');

  /// The logo for FH St.Pölten
  static const logoFhStp = AssetImage('assets/images/logos/fhstp.png');
}
