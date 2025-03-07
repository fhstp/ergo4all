import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  const Page({required this.title, required this.body, super.key});

  final String title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Expanded(child: body ?? Container()),
      ],
    );
  }
}
