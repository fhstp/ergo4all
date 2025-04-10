import 'package:common_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The button style for all primary buttons. It uses a teal color
/// palette.
const primaryTextButtonStyle = ButtonStyle(
  minimumSize: WidgetStatePropertyAll(Size(75, 48)),
  maximumSize: WidgetStatePropertyAll(Size(222, 48)),
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
  minimumSize: WidgetStatePropertyAll(Size(75, 48)),
  maximumSize: WidgetStatePropertyAll(Size(222, 48)),
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
  minimumSize: WidgetStatePropertyAll(Size(75, 48)),
  maximumSize: WidgetStatePropertyAll(Size(222, 48)),
  foregroundColor: WidgetStatePropertyAll(woodSmoke),
  backgroundColor: WidgetStateColor.fromMap({
    WidgetState.pressed: hippieBlue,
    WidgetState.disabled: heather,
    WidgetState.any: spindle,
  }),
);

/// Text style for H1 headers.
const h1Style =
    TextStyle(fontWeight: FontWeight.w700, fontSize: 38, color: cardinal);

/// Text style for H3 headers.
const h3Style =
    TextStyle(fontWeight: FontWeight.w500, fontSize: 36, color: woodSmoke);

/// Text style for H4 headers.
final h4Style = GoogleFonts.nunito(
  fontWeight: FontWeight.w600,
  fontSize: 30,
);
