import 'package:flutter/material.dart';

class PoseTypeSelect extends StatelessWidget {
  final int poseIndex;
  final void Function(int) onSelected;

  const PoseTypeSelect(
      {super.key, required this.poseIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: [
        ButtonSegment(value: 0, label: Text("3D")),
        ButtonSegment(value: 1, label: Text("Coronal")),
        ButtonSegment(value: 2, label: Text("Sagittal")),
      ],
      selected: {poseIndex},
      onSelectionChanged: (selected) {
        onSelected(selected.first);
      },
    );
  }
}
