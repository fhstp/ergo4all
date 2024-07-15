import 'package:flutter/cupertino.dart';

class TappableText extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const TappableText({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Text(text));
  }
}
