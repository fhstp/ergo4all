import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TimedLoadingBar extends HookWidget {
  final Duration duration;
  final VoidCallback? completed;

  const TimedLoadingBar({super.key, required this.duration, this.completed});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
        duration: duration, lowerBound: 0, upperBound: 1);
    final progress = useAnimation(controller);

    useEffect(() {
      controller.forward().then((_) => completed?.call());
      return null;
    }, [completed]);

    return LinearProgressIndicator(
      value: progress,
      semanticsLabel: 'Loading bar',
    );
  }
}
