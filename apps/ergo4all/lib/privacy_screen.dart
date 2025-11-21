import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A screen where users can view privacy information.
class PrivacyScreen extends StatelessWidget {
  ///
  const PrivacyScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'privacy';


  void openPrivacyLink() async {
    Uri link = Uri.parse('https://www.tuwien.at/mwbw/im/ie/mmi/forschung/ergo4a-ergonomics-for-all/datenschutzinformation-projekt-ergo4a');
    if (await canLaunchUrl(link)) {
      await launchUrl(link, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
  }

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const PrivacyScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.privacy_title,
        withBackButton: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: largeSpace),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                localizations.privacy_important,
                style: h3Style,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: largeSpace),
              Text(
                localizations.privacy_content,
                style: staticBodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: largeSpace),

              Text.rich(
                TextSpan(
                  text: localizations.privacy_link,
                  style: dynamicBodyStyle.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = openPrivacyLink,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: largeSpace),
            ],
          ),
        ),
      ),
    );
  }
}
