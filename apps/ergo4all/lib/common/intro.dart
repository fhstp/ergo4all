import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class IntroPage {
  final String title;
  final Widget widget;

  IntroPage({required this.title, required this.widget});
}

class Intro extends HookWidget {
  final List<IntroPage> pages;

  Intro({super.key, required this.pages}) {
    assert(pages.isNotEmpty, "Into can not display 0 pages!");
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    final pageIndex = useState(0);
    final pageController =
        useMemoized(() => PageController(initialPage: pageIndex.value));

    final pageTitle = pages[pageIndex.value].title;

    void navigateToTermsOfUse() {
      navigator.pushNamed(Routes.tou.path);
    }

    return Scaffold(
      appBar: makeCustomAppBar(title: pageTitle),
      body: ScreenContent(
          child: Column(children: [
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (newIndex) => pageIndex.value = newIndex,
            children: pages.map((it) => it.widget).toList(),
          ),
        ),
        ElevatedButton(
            key: const Key("done"),
            style: primaryTextButtonStyle,
            onPressed: navigateToTermsOfUse,
            child: Text(localizations.intro_done))
      ])),
    );
  }
}
