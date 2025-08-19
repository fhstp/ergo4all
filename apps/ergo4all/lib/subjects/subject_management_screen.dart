import 'dart:async';

import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/subjects/creation/screen.dart';
import 'package:flutter/material.dart';

/// Screen where users can manage the subjects filmed by the app.
class SubjectManagementScreen extends StatelessWidget {
  ///
  const SubjectManagementScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'subject-management';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const SubjectManagementScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    void goToSubjectCreator() {
      unawaited(navigator.push(SubjectCreationScreen.makeRoute()));
    }

    return Scaffold(
      appBar: const RedCircleAppBar(
        // TODO: Localize
        titleText: 'Subjects',
        withBackButton: true,
      ),
      body: SafeArea(
        child: Align(
          child: Column(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: goToSubjectCreator,
                style: primaryTextButtonStyle,
                // TODO: Localize
                child: const Text('New Subject'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
