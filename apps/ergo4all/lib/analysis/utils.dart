import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_transforming/normalization.dart';
import 'package:pose_transforming/pose_2d.dart';
import 'package:rula/rula.dart';

/// Extensions for calculating rula sheet from pose.
extension ToSheetExt on Pose {
  /// Calculates the [RulaSheet] from the angles in this [Pose].
  RulaSheet toRulaSheet() {
    final normalized = normalizePose(this);
    final sagittal = make2dSagittalPose(normalized);
    final coronal = make2dCoronalPose(normalized);
    final transverse = make2dTransversePose(normalized);
    final angles = calculateAngles(this, coronal, sagittal, transverse);

    final sheet = rulaSheetFromAngles(angles);
    return sheet;
  }
}
