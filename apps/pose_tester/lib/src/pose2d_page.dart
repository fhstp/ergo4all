import 'package:flutter/material.dart' hide Page, ProgressIndicator;
import 'package:fpdart/fpdart.dart' hide State;
import 'package:pose_tester/src/page.dart';
import 'package:pose_tester/src/progress_indicator.dart';
import 'package:pose_transforming/normalization.dart';
import 'package:pose_transforming/pose_2d.dart';
import 'package:pose_vis/pose_vis.dart';

class Pose2dPage extends StatefulWidget {
  const Pose2dPage({
    required this.normalizedPose,
    required this.makePose2d,
    required this.title,
    super.key,
  });

  final String title;
  final Option<NormalizedPose> normalizedPose;
  final Pose2d Function(NormalizedPose) makePose2d;

  @override
  State<Pose2dPage> createState() => _Pose2dPageState();
}

class _Pose2dPageState extends State<Pose2dPage> {
  Option<Pose2d> pose = none();

  void recalculatePose() {
    setState(() {
      pose = none();
    });

    widget.normalizedPose.match(() {}, (normalizedPose) {
      setState(() {
        pose = Some(widget.makePose2d(normalizedPose));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    recalculatePose();
  }

  @override
  void didUpdateWidget(covariant Pose2dPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    recalculatePose();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      title: widget.title,
      body: pose.match(
        ProgressIndicator.new,
        (pose) => Expanded(
          child: CustomPaint(painter: Pose2dPainter(pose: pose)),
        ),
      ),
    );
  }
}
