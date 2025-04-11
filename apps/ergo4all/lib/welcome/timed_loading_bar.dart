import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TimedLoadingBar extends HookWidget {
  const TimedLoadingBar({required this.duration, super.key, this.completed});
  final Duration duration;
  final VoidCallback? completed;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: duration,
    );
    final progress = useAnimation(controller);

    useEffect(
      () {
        controller.forward().then((_) => completed?.call());
        return null;
      },
      [completed],
    );

    return LinearProgressIndicator(
      value: progress,
      semanticsLabel: 'Loading bar',
    );
  }
}
