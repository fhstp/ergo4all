import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:flutter/material.dart';

/// Screen where users can add new subjects.
class SubjectCreationScreen extends StatelessWidget {
  ///
  const SubjectCreationScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'subject-creation';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const SubjectCreationScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: RedCircleAppBar(
        // TODO: Localize
        titleText: 'New subject',
        withBackButton: true,
      ),
      body: SafeArea(
        child: Align(
          child: Column(),
        ),
      ),
    );
  }
}
