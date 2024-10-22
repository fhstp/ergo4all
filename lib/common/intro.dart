import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroPage {
  final String title;
  final Widget widget;

  IntroPage({required this.title, required this.widget});
}

class Intro extends StatefulWidget {
  final List<IntroPage> pages;

  Intro({super.key, required this.pages}) {
    assert(pages.isNotEmpty, "Into can not display 0 pages!");
  }

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int _pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  void _onPageChanged(int newIndex) {
    setState(() {
      _pageIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    final pageTitle = widget.pages[_pageIndex].title;

    void navigateToTermsOfUse() {
      navigator.pushNamed(Routes.tou.path);
    }

    return Scaffold(
      appBar: makeCustomAppBar(title: pageTitle),
      body: ScreenContent(
          child: Column(children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: widget.pages.map((it) => it.widget).toList(),
          ),
        ),
        ElevatedButton(
            key: const Key("done"),
            onPressed: navigateToTermsOfUse,
            child: Text(localizations.intro_done))
      ])),
    );
  }
}
