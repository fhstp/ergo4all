import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Screen for displaying general information about ergonomics.
class GeneralInfoScreen extends StatelessWidget {
  ///
  const GeneralInfoScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'tip-general';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const GeneralInfoScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(
          localizations.tips_general_title.toUpperCase(),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: largeSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizations.tips_general_ergonomics_explanation,
                style: staticBodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: largeSpace),
              Text(
                localizations.tips_general_factors,
                style: staticBodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: largeSpace),
              Text(
                localizations.tips_general_example,
                style: staticBodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: mediumSpace),
              SvgPicture.asset(
                'assets/images/puppet_scenario/lifting.svg',
                height: 230,
              ),
              const SizedBox(height: mediumSpace),
              Text(
                localizations.tips_general_legs,
                style: staticBodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: largeSpace),
              Text(
                localizations.tips_general_teach,
                style: staticBodyStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
