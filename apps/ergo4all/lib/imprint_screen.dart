import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/common/custom_images.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.imprint,
        withBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: mediumSpace,
          vertical: largeSpace,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              logo: CustomImages.logoFhStp,
              companyName: 'FH St. Pölten',
              companyAddress: '[Address]',
              contactPersonName: '[Contact Name]',
              contactEmail: '[Contact Email]',
              contactTelephone: '[Contact Telephone]',
            ),
            const SizedBox(height: largeSpace),
            const _ContactBlock(
              logo: CustomImages.logoTUWien,
              companyName: 'TU Wien',
              companyAddress: '[Address]',
              contactPersonName: '[Contact Name]',
              contactEmail: '[Contact Email]',
              contactTelephone: '[Contact Telephone]',
            ),
            TextButton(
              onPressed: () {},
              child: Text(localizations.menu_privacy_label),
            ),
          ],
        ),
      ),
    );
  }
}
