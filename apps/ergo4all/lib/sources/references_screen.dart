import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:common_ui/widgets/red_circle_bottom_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class References extends StatelessWidget {
  const References({super.key});

  /// The route name for this screen.
  static const String routeName = 'references';

  /// Creates a [MaterialPageRoute] to navigate to this screen 
  static MaterialPageRoute<void> makeRoute(){
    return MaterialPageRoute(
      builder: (_) => const References(),
      settings: RouteSettings(name: routeName),
    );
  }

  /// Helper method to format a reference entry widget (authors + italic text etc.).
  Widget _reference_entry(BuildContext context, String author, String title) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text.rich(
        TextSpan(
          style: textStyle,
          children: [
            TextSpan(text: '$author\n'),
            TextSpan(
              text: title,
              style: textStyle?.copyWith(fontStyle: FontStyle.italic),
            ),
            ],
          ),
        ),
      );
  }

  @override  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; 

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(
          localizations.sources_refs_nav,
          textAlign: TextAlign.center,
        ),
      ),

      body: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: RedCircleBottomBar(),
          ),

          SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: largeSpace),
            child: Align(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: largeSpace),
                    Text(
                      localizations.sources_refs,
                      style: dynamicBodyStyle,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: mediumSpace),
                    Text(
                      localizations.sources_used,
                      style: h2Style,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: mediumSpace),
                    Text(
                      localizations.sources_used_text,
                      style: dynamicBodyStyle,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: mediumSpace),
                    Text(
                      localizations.sources_research,
                      style: h4Style,
                      textAlign: TextAlign.left,
                    ),

                    // No localization for the following list, as it is not user-facing text but rather a list of sources.
                    const Divider(),
                    const SizedBox(height: mediumSpace),
                    _reference_entry(
                      context,
                      'Black, N. L., Neumann, W. P., & Noy, I. (eds.) (2021)',
                      'Proceedings of the 21st Congress of the International Ergonomics Association (IEA 2021). Lecture Notes in Networks and Systems, Volume 221 – Sector Based Ergonomics.',
                    ),
                    _reference_entry(
                      context,
                      'McAtamney, L., & Corlett, E. N. (1993)',
                      'RULA: A survey method for the investigation of work-related upper limb disorders. Applied Ergonomics, 24(2), 91–99.',
                    ),

                    _reference_entry(
                      context,
                      'Bundesanstalt für Arbeitsschutz und Arbeitsmedizin (BAuA) (2019)',
                      'Gefährdungsbeurteilung bei physischer Belastung – die neuen Leitmerkmalmethoden (LMM). 3rd edition. Dortmund: BAuA.',
                    ),
                    
                    const SizedBox(height: largeSpace),

                    Text(
                      localizations.sources_guidelines,
                      style: h4Style,
                      textAlign: TextAlign.left,
                    ),

                    const Divider(),

                    _reference_entry(
                      context,
                      'Feletto, M. (1999)',
                      'Easy Ergonomics: A Practical Approach for Improving the Workplace. Education and Training Unit, Cal/OSHA Consultation Service, California Department of Industrial Relations.',
                    ),

                    _reference_entry(
                      context,
                      'Feletto, M., & Graze, W. (2002)',
                      'A Back Injury Prevention Guide for Health Care Providers. Education and Training Unit, Cal/OSHA Consultation Service, California Department of Industrial Relations.',
                    ),

                    _reference_entry(
                      context,
                      'Cal/OSHA Consultation Service (2007)',
                      'Ergonomic Guidelines for Manual Material Handling. Research and Education Unit, Division of Occupational Safety and Health, California Department of Industrial Relations.',
                    ),

                    _reference_entry(
                      context,
                      'Arbeiterkammer Wien (AK Wien) (2023)',
                      'Heben und Tragen – Richtig anpacken auf gesunde Art.',
                    ),

                    const SizedBox(height: largeSpace),
                     
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
