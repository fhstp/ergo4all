import 'dart:async';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/sources/explanations_screen.dart';
import 'package:ergo4all/sources/references_screen.dart';
import 'package:ergo4all/sources/code_screen.dart';
import 'package:flutter/material.dart';


/// Screen which lists explanations for further navigation
class SourcesScreen extends StatelessWidget {
  /// Creates a [SourcesScreen].
  const SourcesScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'sources-details';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const SourcesScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void goToExplanationImage(Explanations explanation) {
      unawaited(Navigator.push(context, AboutScreen.makeRoute(explanation))); // SourcesDetailsScreen.makeRoute(Explanations.model)
    }

    void goToCode() {
      unawaited(Navigator.push(context, CodeScreen.makeRoute()));
    }

    void goToReferences() {
      unawaited(Navigator.of(context).push(References.makeRoute()));
    }


    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.choice_title,
        withBackButton: true,
      ),
      body: SafeArea(
        child: Align(
          child: Column(
            children: [
              const SizedBox(height: largeSpace),
              Expanded(
                child: SizedBox(
                  width: 275,
                  child: ListView(
                    children: [
                      ElevatedButton(
                        key: const Key('model_explanation'),
                        style: paleTextButtonStyle,
                        onPressed: () => goToExplanationImage(Explanations.model),
                        child: Text(localizations.sources_model_nav, textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: largeSpace),
                      ElevatedButton(
                        key: const Key('data_explanation'),
                        style: paleTextButtonStyle,
                        onPressed: () => goToExplanationImage(Explanations.rula),
                        child: Text(localizations.sources_ergonomics_nav, textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: largeSpace),
                      ElevatedButton(
                        key: const Key('code_reference'),
                        style: paleTextButtonStyle,
                        onPressed: goToCode,
                        child: Text(localizations.sources_code_nav, textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: largeSpace),
                      ElevatedButton(
                        key: const Key('sources_references'),
                        style: paleTextButtonStyle,
                        onPressed: goToReferences,
                        child: Text(localizations.sources_refs_nav, textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: largeSpace),
                      Text( 
                        localizations.sources_disclaimer,
                        style: dynamicBodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ),
              ),
              const SizedBox(height: largeSpace),
            ],
          ),
        ),
      ),
    );
  }
}

