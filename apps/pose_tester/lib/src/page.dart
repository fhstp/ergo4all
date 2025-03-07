import 'package:flutter/material.dart';

/// A page with a title and body.
class Page extends StatelessWidget {
  /// Creates a [Page].
  const Page({required this.title, required this.body, super.key});

  /// The pages title.
  final String title;

  /// The pages body.
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
