import 'package:ergo4all/widgets/screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfessionalIntro extends StatefulWidget {
  const ProfessionalIntro({super.key});

  @override
  State<ProfessionalIntro> createState() => _ProfessionalIntroState();
}

class _ProfessionalIntroState extends State<ProfessionalIntro> {
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
    final appTheme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final titles = [
      localizations.professionalIntro_overview_title,
      localizations.professionalIntro_privacy_title
    ];

    final skipButton = TextButton(onPressed: () {}, child: const Text("Skip"));

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_pageIndex]),
      ),
      body: ScreenContent(
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              Column(
                children: [
                  Text(
                    localizations.professionalIntro_overview_header,
                    style: appTheme.textTheme.headlineLarge,
                  ),
                  Text(localizations.professionalIntro_overview_text),
                  skipButton
                ],
              ),
              Column(
                children: [
                  Text(
                    localizations.professionalIntro_privacy_header,
                    style: appTheme.textTheme.headlineLarge,
                  ),
                  Text(localizations.professionalIntro_privacy_text),
                  skipButton
                ],
              )
            ],
          )),
    );
  }
}
