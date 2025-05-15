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
final h1Style = GoogleFonts.montserrat(
  fontWeight: FontWeight.w700,
  fontSize: 38,
  color: cardinal,
);

/// Text style for H2 headers.
final h2Style = GoogleFonts.montserrat(
  fontWeight: FontWeight.w700,
  fontSize: 36,
  color: woodSmoke,
);

/// Text style for H3 headers.
final h3Style = GoogleFonts.montserrat(
  fontWeight: FontWeight.w500,
  fontSize: 36,
  color: woodSmoke,
);

/// Text style for H4 headers.
final h4Style = GoogleFonts.nunito(
  fontWeight: FontWeight.w600,
  fontSize: 30,
  color: woodSmoke,
);

/// Small header for paragraphs
/// This corresponds to "Überschrift Fließtext" in the Figma.
final paragraphHeaderStyle = GoogleFonts.nunito(
  fontWeight: FontWeight.w700,
  fontSize: 20,
  color: woodSmoke,
);

/// Body text for static content
/// This corresponds to "Fließtext statisch" in the Figma.
final staticBodyStyle = GoogleFonts.nunito(
  fontWeight: FontWeight.w400,
  fontSize: 24,
  color: woodSmoke,
);

/// Body text for dynamic content
/// This corresponds to "Fließtext dynamisch" in the Figma.
final dynamicBodyStyle = GoogleFonts.nunito(
  fontWeight: FontWeight.w400,
  fontSize: 20,
  color: woodSmoke,
);

/// Text style for text input fields.
/// This corresponds to "Eingabefeld" in the Figma.
final inputTextStyle = GoogleFonts.nunito(
  fontWeight: FontWeight.w400,
  fontSize: 20,
  color: woodSmoke,
);

/// Text style for smaller info texts.
/// This corresponds to "Infotext" in the Figma.
final infoText = GoogleFonts.nunito(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: woodSmoke,
);
