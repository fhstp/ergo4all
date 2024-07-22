import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String content;

  const Header(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineLarge;
    return Text(content, style: style);
  }
}
