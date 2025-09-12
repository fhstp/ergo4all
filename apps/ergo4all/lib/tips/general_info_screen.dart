import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:flutter/material.dart';

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
    return const Placeholder();
  }
}
