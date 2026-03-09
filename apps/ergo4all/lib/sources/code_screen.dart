import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:common_ui/widgets/red_circle_bottom_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class CodeScreen extends StatelessWidget {
  const CodeScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'code-reference';

  /// Creates a [MaterialPageRoute] to navigate to this screen 
  static MaterialPageRoute<void> makeRoute(){
    return MaterialPageRoute(
      builder: (_) => const CodeScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; 

    Future<void> RedirectToCode() async {
      final link = Uri.parse(
        'https://github.com/fhstp/ergo4all',
      );
      await launchUrl(link, mode: LaunchMode.externalApplication);
    }

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(
          localizations.sources_code_nav,
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
                  children: [
                    const SizedBox(height: largeSpace),
                    Text(
                      localizations.sources_code,
                      style: dynamicBodyStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: mediumSpace),

                    RichText(                      
                      text: TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = RedirectToCode,
                        text: localizations.sources_code_link,
                        style: dynamicBodyStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      textAlign: TextAlign.center,
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
