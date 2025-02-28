// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:rula/rula.dart';

@immutable
class ScoreSheet {
  final RulaScore upperArm;
  final RulaScore lowerArm;
  final RulaScore neck;
  final RulaScore neckFlexion;
  final RulaScore trunk;
  final RulaScore leg;
  final RulaScore full;

  const ScoreSheet({
    required this.upperArm,
    required this.lowerArm,
    required this.neck,
    required this.neckFlexion,
    required this.trunk,
    required this.leg,
    required this.full,
  });
}
