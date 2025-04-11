import 'package:common_ui/theme/spacing.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(this.content, {super.key});
  final String content;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineLarge;
    return Column(
      children: [
        Text(content, style: style),
        const SizedBox(
          height: largeSpace,
        ),
      ],
    );
  }
}
