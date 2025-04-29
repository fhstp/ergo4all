import 'dart:math';

import 'package:common/pair_utils.dart';
import 'package:common_ui/theme/colors.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail_page.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

/// Creates fake RULA sheet with random scores
RulaSheet _createFakeSheet() {
  final random = Random();

  var r1 = Degree.makeFrom180(random.nextInt(180).toDouble());
  var r2 = Degree.makeFrom180(random.nextInt(180).toDouble());
  var r3 = Degree.makeFrom180(random.nextInt(180).toDouble());

  return RulaSheet(
    shoulderFlexion: (
      r1, // Random value 0-180
      r2
    ),
    shoulderAbduction: Pair.of(r1),
    elbowFlexion: (
      r2,
      r3
    ),
    wristFlexion: Pair.of(r3),
    neckFlexion: r1,
    neckRotation: r2,
    neckLateralFlexion: r3,
    hipFlexion: r2,
    trunkRotation: r1,
    trunkLateralFlexion: r1,
    isStandingOnBothLegs: random.nextBool(),
  );
}

/// Creates fake timeline data for testing
RulaTimeline createFakeTimeline() {
  final now = DateTime.now().millisecondsSinceEpoch;
  final entries = List.generate(
    30, // 100 data points
    (index) => TimelineEntry(
      timestamp: now + (index * 100), // 100ms intervals
      sheet: _createFakeSheet(),
    ),
  );
  
  return IList(entries);
}

@immutable
/// Manages colors for the RULA score visualization
class ColorMapper {
  /// Maps normalized RULA score values to colors
  static Color getColorForValue(double value) {
    if (value < 0.20) {
      return rulaLow;
    } else if (value <= 0.40) {
      return rulaLowMid;
    } else if (value <= 0.60) {
      return rulaMid;
    } else if (value <= 0.80) {
      return rulaMidHigh;
    }
    return rulaHigh;
  }
}

@immutable
class TimelineEntry {
  const TimelineEntry({required this.timestamp, required this.sheet});

  final int timestamp;
  final RulaSheet sheet;
}

typedef RulaTimeline = IList<TimelineEntry>;

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  static RulaTimeline timeline = createFakeTimeline();

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final Random random = Random();

  void _navigateToBodyPartPage(
    String bodyPart,
    List<FlSpot> timelineData,
    List<FlSpot> avgTimelineData,
  ) {
    final timelineColors = timelineData.map((spot) {
      return ColorMapper.getColorForValue(spot.y);
    }).toList();

    final timelineValues = timelineData.map((spot) { return spot.y; }).toList();

    final avgTimelineColors = avgTimelineData.map((spot) {
      return ColorMapper.getColorForValue(spot.y);
    }).toList();

    final avgTimelineValues = avgTimelineData.map((spot) { return spot.y; }).toList();

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BodyPartDetailPage(
          bodyPart: bodyPart,
          timelineColors: timelineColors,
          timelineValues: timelineValues,
          avgTimelineColors: avgTimelineColors,
          avgTimelineValues: avgTimelineValues,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final labels = [
      localizations.results_body_upper_arms,
      localizations.results_body_lower_arms,
      localizations.results_body_trunk,
      localizations.results_body_neck,
      localizations.results_body_legs,
    ];
    final timeline =
        ResultsScreen.timeline;

    // final timeline =
    //   ModalRoute.of(context)!.settings.arguments! as RulaTimeline;

    final firstTimestamp = timeline.first.timestamp;
    final lastTimestamp = timeline.last.timestamp;
    final timeRange = lastTimestamp - firstTimestamp;

    double graphXFor(int timestamp) {
      return (timestamp - firstTimestamp) / timeRange;
    }

    double graphYFor(RulaScore score, int maxValue) {
      final value = score.value;
      return (value - 1) / (maxValue - 1);
    }

    List<FlSpot> graphLineFor(
      RulaScore Function(RulaSheet) selector,
      int maxValue,
    ) {
      return timeline.map((entry) {
        final score = selector(entry.sheet);
        final x = graphXFor(entry.timestamp);
        final y = graphYFor(score, maxValue);
        return FlSpot(x, y);
      }).toList();
    }

    List<FlSpot> calculateRunningAverage(List<FlSpot> data, int windowSize) {
      if (data.length < windowSize) return data;
      
      final result = <FlSpot>[];
      
      for (var i = 0; i <= data.length - windowSize; i++) {
        final window = data.sublist(i, i + windowSize);
        final avgY = window.map((spot) => spot.y).reduce((a, b) => a + b) / windowSize;
        final avgX = window[windowSize ~/ 2].x; // Use middle point's x value
        result.add(FlSpot(avgX, avgY));
      }
      
      return result;
    }

    final lineChartData = IList([
      graphLineFor(calcUpperArmScore, 6),
      graphLineFor(calcLowerArmScore, 3),
      graphLineFor(calcTrukScore, 6),
      graphLineFor(calcNeckScore, 6),
      graphLineFor(calcLegScore, 2),
    ]);

    final avgLineChartData = IList(
      lineChartData.map((spots) => calculateRunningAverage(spots, 5)).toList()
    );

    final heatmapHeight = MediaQuery.of(context).size.width * 0.6;
    final heatmapWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.results_title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // 'Normalized RULA Score Analysis',
              localizations.results_plot_title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // Heatmap
            Center(
              child: SizedBox(
                width: heatmapWidth,
                height: heatmapHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: GestureDetector(
                    onTapDown: (details) {
                      // Find row of the bar that was tapped
                      final rowHeight = heatmapHeight / labels.length;
                      final rowIndex = (details.localPosition.dy / rowHeight).floor();
                      if (rowIndex >= 0 && rowIndex < labels.length) {
                        _navigateToBodyPartPage(
                          labels[rowIndex],
                          lineChartData[rowIndex],
                          avgLineChartData[rowIndex],
                        );
                      }
                    },
                    child: CustomPaint(
                      painter: HeatmapPainter(
                        data: lineChartData.map((spots) {
                          return spots.map((spot) => spot.y).toList();
                        }).toList(),
                        rows: labels.length,
                        timestamps: timeline.map((entry) => entry.timestamp).toList(),
                        labels: labels,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Color legend
            Center(
              child: SizedBox(
                height: 50,
                width: heatmapWidth,
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [
                            rulaLow,
                            rulaLowMid,
                            rulaMid,
                            rulaMidHigh,
                            rulaHigh,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localizations.results_score_low, 
                            style: const TextStyle(fontSize: 14)),
                        Text(localizations.results_score_high, 
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeatmapPainter extends CustomPainter {
  HeatmapPainter({
    required this.data,
    required this.rows,
    required this.timestamps,
    required this.labels, // Add this parameter
  });

  final List<List<double>> data;
  final int rows;
  final List<int> timestamps;
  final List<String> labels; // Add this field

@override
void paint(Canvas canvas, Size size) {
  const spacing = 10.0; // Space between rows
  final cellWidth = size.width / timestamps.length;
  final availableHeight = size.height - (spacing * (rows - 1)); // Subtract total spacing
  final cellHeight = availableHeight / rows;
  final paint = Paint()..style = PaintingStyle.fill;
  final textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.right,
  );

  // Draw heatmap cells
  for (var row = 0; row < rows; row++) {
    final yOffset = row * (cellHeight + spacing); // Add spacing to y position

    for (var col = 0; col < timestamps.length; col++) {
      final value = data[row][col];
      paint.color = ColorMapper.getColorForValue(value);

      canvas.drawRect(
        Rect.fromLTWH(
          col * cellWidth,
          yOffset,
          cellWidth,
          cellHeight,
        ),
        paint,
      );
    }

    // Draw row labels
    textPainter.text = TextSpan(
      text: labels[row].replaceAll(' ', '\n'),
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
      ),
    );
    textPainter.layout(maxWidth: 60);
    textPainter.paint(
      canvas,
      Offset(
        -textPainter.width - 8,
        yOffset + (cellHeight - textPainter.height) / 2,
      ),
    );
  }
}

  @override
  bool shouldRepaint(HeatmapPainter oldDelegate) => false;

}
