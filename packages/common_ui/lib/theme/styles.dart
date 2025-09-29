import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text style for button labels.
final buttonLabelStyle =
    GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 20);

/// The intended width for most buttons in the app.
const buttonWidth = 220.0;

/// Button style for elevated buttons in the app.
final elevatedButtonStyle = ButtonStyle(
  minimumSize: const WidgetStatePropertyAll(Size(128, 48)),
  fixedSize: const WidgetStatePropertyAll(Size.fromWidth(buttonWidth)),
  maximumSize: const WidgetStatePropertyAll(Size.fromWidth(buttonWidth)),
  padding: const WidgetStatePropertyAll(
    EdgeInsets.symmetric(
      vertical: smallSpace,
      horizontal: mediumSpace,
    ),
  ),
  textStyle: WidgetStatePropertyAll(buttonLabelStyle),
  elevation: const WidgetStatePropertyAll(3),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  alignment: Alignment.center,
);

/// The button style for all primary buttons. It uses a teal color
/// palette.
final primaryTextButtonStyle = elevatedButtonStyle.copyWith(
  foregroundColor: const WidgetStatePropertyAll(white),
  backgroundColor: const WidgetStateColor.fromMap({
    WidgetState.pressed: tealBlue,
    WidgetState.disabled: heather,
    WidgetState.any: blueChill,
  }),
);

/// The button style for all secondary buttons. It uses a dark blue color
/// palette.
final secondaryTextButtonStyle = elevatedButtonStyle.copyWith(
  foregroundColor: const WidgetStatePropertyAll(white),
  backgroundColor: const WidgetStateColor.fromMap({
    WidgetState.pressed: blackPearl,
    WidgetState.disabled: heather,
    WidgetState.any: tarawera,
  }),
);

/// The button style for all buttons which are surrounded by a lot of white.
/// It uses the pale blue color palette.
final paleTextButtonStyle = elevatedButtonStyle.copyWith(
  foregroundColor: const WidgetStatePropertyAll(woodSmoke),
  backgroundColor: const WidgetStateColor.fromMap({
    WidgetState.pressed: hippieBlue,
    WidgetState.disabled: heather,
    WidgetState.any: spindle,
  }),
);

/// The button style for red buttons, such as error buttons.
final redTextButtonStyle = elevatedButtonStyle.copyWith(
  foregroundColor: const WidgetStatePropertyAll(white),
  backgroundColor: const WidgetStateColor.fromMap({
    WidgetState.pressed: persimmon,
    WidgetState.disabled: persimmon,
    WidgetState.any: cardinal,
  }),
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
  fontSize: 24,
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
