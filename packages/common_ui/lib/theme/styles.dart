import 'package:common_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text style for button labels.
final buttonLabelStyle =
    GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 20);

/// The button style for all primary buttons. It uses a teal color
/// palette.
final primaryTextButtonStyle = ButtonStyle(
  minimumSize: const WidgetStatePropertyAll(Size(75, 48)),
  maximumSize: const WidgetStatePropertyAll(Size(222, 48)),
  foregroundColor: const WidgetStatePropertyAll(white),
  backgroundColor: const WidgetStateColor.fromMap({
    WidgetState.pressed: tealBlue,
    WidgetState.disabled: heather,
    WidgetState.any: blueChill,
  }),
  textStyle: WidgetStatePropertyAll(buttonLabelStyle),
);

/// The button style for all secondary buttons. It uses a dark blue color
/// palette.
final secondaryTextButtonStyle = ButtonStyle(
  minimumSize: const WidgetStatePropertyAll(Size(75, 48)),
  maximumSize: const WidgetStatePropertyAll(Size(222, 48)),
  foregroundColor: const WidgetStatePropertyAll(white),
  backgroundColor: const WidgetStateColor.fromMap({
    WidgetState.pressed: blackPearl,
    WidgetState.disabled: heather,
    WidgetState.any: tarawera,
  }),
  textStyle: WidgetStatePropertyAll(buttonLabelStyle),
);

/// The button style for all buttons which are surrounded by a lot of white.
/// It uses the pale blue color palette.
final paleTextButtonStyle = ButtonStyle(
  minimumSize: const WidgetStatePropertyAll(Size(75, 48)),
  maximumSize: const WidgetStatePropertyAll(Size(222, 48)),
  foregroundColor: const WidgetStatePropertyAll(woodSmoke),
  backgroundColor: const WidgetStateColor.fromMap({
    WidgetState.pressed: hippieBlue,
    WidgetState.disabled: heather,
    WidgetState.any: spindle,
  }),
  textStyle: WidgetStatePropertyAll(buttonLabelStyle),
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

/// Small header for paragraphs
final paragraphHeader =
    GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 20);

/// Text style for body text
final infoText = GoogleFonts.nunito(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: woodSmoke,
);