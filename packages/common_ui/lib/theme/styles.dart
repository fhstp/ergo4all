import 'package:common_ui/theme/colors.dart';
import 'package:flutter/material.dart';

/// The button style for all primary buttons. It uses a teal color
/// palette.
const primaryTextButtonStyle = ButtonStyle(
  foregroundColor: WidgetStatePropertyAll(white),
  backgroundColor: WidgetStateColor.fromMap({
    WidgetState.pressed: tealBlue,
    WidgetState.disabled: heather,
    WidgetState.any: blueChill,
  }),
);

/// The button style for all secondary buttons. It uses a dark blue color
/// palette.
const secondaryTextButtonStyle = ButtonStyle(
  foregroundColor: WidgetStatePropertyAll(white),
  backgroundColor: WidgetStateColor.fromMap({
    WidgetState.pressed: blackPearl,
    WidgetState.disabled: heather,
    WidgetState.any: tarawera,
  }),
);

/// The button style for all buttons which are surrounded by a lot of white.
/// It uses the pale blue color palette.
const paleTextButtonStyle = ButtonStyle(
  foregroundColor: WidgetStatePropertyAll(woodSmoke),
  backgroundColor: WidgetStateColor.fromMap({
    WidgetState.pressed: hippieBlue,
    WidgetState.disabled: heather,
    WidgetState.any: spindle,
  }),
);
