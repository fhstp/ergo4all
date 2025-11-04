import 'dart:async';

import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/common/custom_images.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/privacy_screen.dart';
import 'package:flutter/material.dart';

class _ContactBlock extends StatelessWidget {
  const _ContactBlock({
    required this.logo,
    required this.companyName,
    required this.companyAddress,
    required this.contactPersonName,
    required this.contactEmail,
    required this.contactTelephone,
  });

  final AssetImage logo;
  final String companyName;
  final String companyAddress;
  final String contactPersonName;
  final String contactEmail;
  final String contactTelephone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: logo, height: 35),
        const SizedBox(height: mediumSpace),
        Text(companyName),
        Text(companyAddress),
        Text(contactPersonName),
        Text(contactEmail),
        Text(contactTelephone),
      ],
    );
  }
}

/// Screen for displaying information about project partners and contributors.
class ImprintScreen extends StatelessWidget {
  ///
  const ImprintScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'imprint';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const ImprintScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void goToPrivacy() {
      unawaited(Navigator.of(context).push(PrivacyScreen.makeRoute()));
    }

    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.imprint,
        withBackButton: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: mediumSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: largeSpace),
              const _ContactBlock(
                logo: CustomImages.logoAk,
                companyName: 'AK Niederösterreich',
                companyAddress: '[Address]',
                contactPersonName: '[Contact Name]',
                contactEmail: '[Contact Email]',
                contactTelephone: '[Contact Telephone]',
              ),
              const SizedBox(height: largeSpace),
              const _ContactBlock(
                logo: CustomImages.logoUstp,
                companyName: 'FH St. Pölten',
                companyAddress: 'Campus-Platz 1, A-3100 St. Pölten',
                contactPersonName: 'Christian Jandl',
                contactEmail: 'christian.jandl@fhstp.ac.at',
                contactTelephone: '+43676847228618',
              ),
              const SizedBox(height: largeSpace),
              const _ContactBlock(
                logo: CustomImages.logoTUWien,
                companyName: 'TU Wien',
                companyAddress: 'Theresianumgasse 27, 1040 Wien',
                contactPersonName: 'David Kostolani',
                contactEmail: 'david.kostolani@tuwien.ac.at',
                contactTelephone: '',
              ),
              TextButton(
                onPressed: goToPrivacy,
                child: Text(localizations.menu_privacy_label),
              ),
              const SizedBox(height: largeSpace),
            ],
          ),
        ),
      ),
    );
  }
}
