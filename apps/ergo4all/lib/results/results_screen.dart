import 'dart:math';

import 'package:ergo4all/results/body_part_detail_page.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';
import 'package:common/pair_utils.dart';

import 'dart:math';

/// Creates fake RULA sheet with random scores
RulaSheet _createFakeSheet() {
    // return RulaSheet(
    //   shoulderFlexion: (
    //   const Degree.makeFrom180(120),
    //   const Degree.makeFrom180(110)
    //   ),
    //   shoulderAbduction: Pair.of(Degree.zero),
    //   elbowFlexion: (
    //   const Degree.makeFrom180(80),
    //   const Degree.makeFrom180(70)
    //   ),
    //   wristFlexion: Pair.of(Degree.zero),
    //   neckFlexion: const Degree.makeFrom180(-30),
    //   neckRotation: Degree.zero,
    //   neckLateralFlexion: Degree.zero,
    //   hipFlexion: Degree.zero,
    //   trunkRotation: Degree.zero,
    //   trunkLateralFlexion: Degree.zero,
    //   isStandingOnBothLegs: true,
    // );
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
    20, // 100 data points
    (index) => TimelineEntry(
      timestamp: now + (index * 100), // 100ms intervals
      sheet: _createFakeSheet(),
    ),
  );
  
  return IList(entries);
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
  final List<String> labels = [
    'Upper Arm',
    'Lower Arm',
    'Trunk',
    'Neck',
    'Legs',
  ];

  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  final Random random = Random();

  void _navigateToBodyPartPage(
    String bodyPart,
    Color color,
    List<FlSpot> timelineData,
  ) {
    // Map the y-values of FlSpot to specific colors

    // final List<Color> gradientColors = [
    //   const Color.fromARGB(255, 123, 194, 255), // Good (Blue)
    //   const Color.fromARGB(255, 255, 218, 10),  // Improve (Yellow)
    //   const Color.fromARGB(255, 220, 50, 32),   // Bad (Red)
    // ];
    //
    // final List<Color> timelineColors = timelineData.map((spot) {
    //   final value = spot.y.clamp(0.0, 1.0);
    //
    //   if (value <= 0.5) {
    //     // Interpolate between first and second color
    //     return Color.lerp(
    //       gradientColors[0],
    //       gradientColors[1],
    //       value * 2, // Scale 0-0.5 to 0-1
    //     )!;
    //   } else {
    //     // Interpolate between second and third color
    //     return Color.lerp(
    //       gradientColors[1],
    //       gradientColors[2],
    //       (value - 0.5) * 2, // Scale 0.5-1 to 0-1
    //     )!;
    //   }
    // }).toList();


    var good = const Color.fromARGB(255, 123, 194, 255); // Good (Blue)
    var mid = const Color.fromARGB(255, 255, 218, 10);  // Improve (Yellow)
    var bad = const Color.fromARGB(255, 220, 50, 32);   // Bad (Red)

    final List<Color> timelineColors = timelineData.map((spot) {
      if (spot.y < 0.33) {
        return good; // Good
      } else if (spot.y < 0.66) {
        return mid; // Improve
      } else {
        return bad; // Bad
      }
    }).toList();

    final List<double> timelineValues = timelineData.map((spot) { return spot.y; }).toList();

    // Navigate to BodyPartDetailPage with the updated timelineColors

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BodyPartDetailPage(
          bodyPart: bodyPart,
          color: color,
          timelineColors: timelineColors,
          timelineValues: timelineValues,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeline =
        ResultsScreen.timeline;

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

    final lineChartData = IList([
      graphLineFor(calcUpperArmScore, 6),
      graphLineFor(calcLowerArmScore, 3),
      graphLineFor(calcTrukScore, 6),
      graphLineFor(calcNeckScore, 6),
      graphLineFor(calcLegScore, 2),
    ]);

    return Scaffold(
      appBar: AppBar(title: const Text('Charts Overview')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Normalized RULA Score Analysis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 10,
              runSpacing: 5,
              children: List.generate(labels.length, (index) {
                return GestureDetector(
                  onTap: () => _navigateToBodyPartPage(
                    labels[index],
                    colors[index],
                    lineChartData[index],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: colors[index],
                      ),
                      const SizedBox(width: 5),
                      Text(labels[index], style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.95, // Adjusted for larger width

                height: MediaQuery.of(context).size.width *
                    0.7, // Adjusted for a proportional height

                margin: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ChartBackgroundPainter(minY: 0, maxY: 1),
                        ),
                      ),
                      LineChart(
                        LineChartData(
                          lineBarsData: [
                            for (int i = 0; i < lineChartData.length; i++)
                              LineChartBarData(
                                spots: lineChartData[i],
                                color: colors[i],
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                              ),
                          ],
                          minY: 0,
                          maxY: 1,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                interval: 0.5,
                                getTitlesWidget: (value, meta) {
                                  // Explicitly define labels for fixed
                                  // positions
                                  if (value == 0) {
                                    return const Text(
                                      'OK',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  } else if (value == 0.5) {
                                    return const Text(
                                      'Check',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  } else if (value == 1) {
                                    return const Text(
                                      'Improve',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  }

                                  return const SizedBox(); // Hide other labels
                                },

                                //interval: 1, // Ensure consistent spacing
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  if (value % 30 == 0) {
                                    // Assuming 30 data points per second
                                    final seconds = value / 30;

                                    return Text(
                                      '${seconds.toStringAsFixed(1)} s',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }

                                  return const SizedBox();
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(),
                            topTitles: const AxisTitles(),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartBackgroundPainter extends CustomPainter {
  ChartBackgroundPainter({required this.minY, required this.maxY});
  final double minY;
  final double maxY;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    double mapYToCanvas(double y) {
      return size.height - ((y - minY) / (maxY - minY) * size.height);
    }

    // Green region (Good)

    paint.color = const Color.fromARGB(255, 123, 194, 255).withValues(alpha: 0.2);

    canvas.drawRect(
      Rect.fromLTRB(0, mapYToCanvas(0.33), size.width, size.height),
      paint,
    );

    // Yellow region (Improve)

    paint.color = Colors.yellow.withValues(alpha: 0.2);

    canvas.drawRect(
      Rect.fromLTRB(0, mapYToCanvas(0.66), size.width, mapYToCanvas(0.33)),
      paint,
    );

    // Red region (Bad)

    paint.color = Colors.red.withValues(alpha: 0.2);

    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, mapYToCanvas(0.66)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
