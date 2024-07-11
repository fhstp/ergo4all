import 'package:flutter/material.dart';

class TimedLoadingBar extends StatefulWidget {
  final Duration duration;
  final VoidCallback? completed;

  const TimedLoadingBar({super.key, required this.duration, this.completed});

  @override
  State<StatefulWidget> createState() {
    return _TimedLoadingBarState();
  }
}

class _TimedLoadingBarState extends State<TimedLoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  _onProgress() {
    final progress = controller.value;
    if (progress < 1) {
      setState(() {});
      return;
    }

    widget.completed?.call();
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: widget.duration, lowerBound: 0, upperBound: 1);
    controller
      ..addListener(_onProgress)
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: controller.value,
      semanticsLabel: 'Loading bar',
    );
  }
}
