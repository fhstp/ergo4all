import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/routes.dart';
import 'package:ergo4all/service/get_current_user.dart';
import 'package:ergo4all/ui/spacing.dart';
import 'package:ergo4all/ui/widgets/screen_content.dart';
import 'package:ergo4all/ui/widgets/timed_loading_bar.dart';
import 'package:ergo4all/ui/widgets/version_display.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late Future<User?> _currentUser;

  @override
  void initState() {
    super.initState();

    final getIt = GetIt.instance;

    // We start getting the current user in the background
    final getCurrentUser = getIt.get<GetCurrentUser>();
    _currentUser = getCurrentUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final customLocale = Provider.of<CustomLocale>(context);
    customLocale.load();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    void navigateToNextScreen() async {
      final currentUser = await _currentUser;
      final isFirstStart = currentUser == null;
      // Depending on whether this is the first time we start the app
      // we either go to onboarding or home.
      final nextRoute = isFirstStart ? Routes.language : Routes.home;

      navigator.pushReplacementNamed(nextRoute.path);
    }

    return Scaffold(
      body: ScreenContent(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                      image: AssetImage('assets/images/logos/LogoRed.png')),
                  const SizedBox(
                    height: largeSpace,
                  ),
                  TimedLoadingBar(
                    duration: const Duration(seconds: 3),
                    completed: navigateToNextScreen,
                  )
                ],
              ),
            ),
            const VersionDisplay()
          ],
        ),
      ),
    );
  }
}
