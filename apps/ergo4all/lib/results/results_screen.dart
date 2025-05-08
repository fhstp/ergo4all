import 'dart:math';

import 'package:common/pair_utils.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail_page.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
  /// #BFD7EA
  static const rulaLow = Color(0xFFBFD7EA);

  /// #F9F9C4
  // Use for better visibility in the heatmap plot
  static const rulaLowMid = Color(0xFFF9F9C4);

  /// #DEDEA2
  // Use for better visibility in the line plot
  static const rulaLowMidDark = Color(0xFFE7E7B2);

  /// #FFE553
  static const rulaMid = Color(0xFFFFE553);

  /// #FFA259
  static const rulaMidHigh = Color(0xFFFFA259);

  /// #FF5A5F
  static const rulaHigh = Color(0xFFFF5A5F);

  /// Maps normalized RULA score values to colors
  static Color getColorForValue(double value, {bool dark = false}) {
    if (value < 0.20) {
      return rulaLow;
    } else if (value <= 0.40) {
      return dark ? rulaLowMidDark : rulaLowMid;
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
    List<double> timelineData,
    List<double> avgTimelineValues,
    List<double> medianTimelineValues,
  ) {
    final timelineColors = timelineData.map((spot) {
      return ColorMapper.getColorForValue(spot, dark: true);
    }).toList();

    final timelineValues = timelineData.map((spot) { return spot; }).toList();

    final avgTimelineColors = avgTimelineValues.map((spot) {
      return ColorMapper.getColorForValue(spot, dark: true);
    }).toList();


    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BodyPartDetailPage(
          bodyPart: bodyPart,
          timelineColors: timelineColors,
          timelineValues: timelineValues,
          avgTimelineColors: avgTimelineColors,
          avgTimelineValues: avgTimelineValues,
          medianTimelineValues: medianTimelineValues,
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

    double graphYFor(RulaScore score, int maxValue) {
      final value = score.value;
      return (value - 1) / (maxValue - 1);
    }

    List<double> transformData(
      RulaScore Function(RulaSheet) selector,
      int maxValue,
    ) {
      return timeline.map((entry) {
        final score = selector(entry.sheet);
        final y = graphYFor(score, maxValue);
        return y;
      }).toList();
    }

    List<double> calculateRunningAverage(List<double> data, int windowSize) {
      if (data.length < windowSize) return data;
      
      final result = <double>[];
      
      for (var i = 0; i <= data.length - windowSize; i++) {
        final window = data.sublist(i, i + windowSize);
        final avgY = window.map((spot) => spot).reduce((a, b) => a + b) / windowSize;
        result.add(avgY);
      }
      
      return result;
    }

    List<double> calculateRunningMedian(List<double> data, int windowSize) {
      if (data.length < windowSize) return data;
      
      final result = <double>[];
      
      for (var i = 0; i <= data.length - windowSize; i++) {
        final window = data.sublist(i, i + windowSize)
        
        // Sort the window values
        ..sort();
        
        // Calculate median
        final median = windowSize.isOdd
            ? window[windowSize ~/ 2]
            : (window[(windowSize - 1) ~/ 2] + window[windowSize ~/ 2]) / 2;
        
        result.add(median);
      }
      
      return result;
    }

    final lineChartData = IList([
      transformData(calcUpperArmScore, 6),
      transformData(calcLowerArmScore, 3),
      transformData(calcTrukScore, 6),
      transformData(calcNeckScore, 6),
      transformData(calcLegScore, 2),
    ]);

    final avgLineChartData = IList(
      lineChartData.map((spots) => calculateRunningAverage(spots, 20)).toList(),
    );

    final medianTimelineValues = IList(
      lineChartData.map((spots) => calculateRunningMedian(spots, 60)).toList(),
    );

    final heatmapHeight = MediaQuery.of(context).size.width * 0.6;
    final heatmapWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.results_title, style: h3Style)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // 'Normalized RULA Score Analysis',
              localizations.results_plot_title,
              style: h4Style,
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
                          medianTimelineValues[rowIndex],
                        );
                      }
                    },
                    child: CustomPaint(
                      painter: HeatmapPainter(
                        data: avgLineChartData,
                        rows: labels.length,
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
                            ColorMapper.rulaLow,
                            ColorMapper.rulaLowMid,
                            ColorMapper.rulaMid,
                            ColorMapper.rulaMidHigh,
                            ColorMapper.rulaHigh,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localizations.results_score_low, 
                            style: infoText,),
                        Text(localizations.results_score_high, 
                            style: infoText,),
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
    required this.labels, // Add this parameter
  });

  final IList<List<double>> data;
  final int rows;
  final List<String> labels; 

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 10.0; // Space between rows
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
      final cellWidth = size.width / data[row].length;

      for (var col = 0; col < data[row].length; col++) {
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

      final infoTextSmall = infoText.copyWith(fontSize: 14);

      // Draw row labels
      textPainter..text = TextSpan(
        text: labels[row].replaceAll(' ', '\n'),
        style: infoTextSmall,
      )
      ..layout(maxWidth: 60)
      ..paint(
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
