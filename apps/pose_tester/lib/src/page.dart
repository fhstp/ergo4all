import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  final String title;
  final Widget? body;

  const Page({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 10),
        Expanded(child: body ?? Container())
      ],
    );
  }
}
