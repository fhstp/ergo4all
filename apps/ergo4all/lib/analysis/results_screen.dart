import 'dart:math';

import 'package:ergo4all/analysis/body_part_detail_page.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

@immutable
class TimelineEntry {
  const TimelineEntry({required this.timestamp, required this.sheet});

  final int timestamp;
  final RulaSheet sheet;
}

typedef RulaTimeline = IList<TimelineEntry>;

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

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

    final List<Color> timelineColors = timelineData.map((spot) {
      if (spot.y < 0.33) {
        return Colors.green; // Good
      } else if (spot.y < 0.66) {
        return Colors.yellow; // Improve
      } else {
        return Colors.red; // Bad
      }
    }).toList();

    // Navigate to BodyPartDetailPage with the updated timelineColors

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BodyPartDetailPage(
          bodyPart: bodyPart,
          color: color,
          timelineColors: timelineColors,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeline =
        ModalRoute.of(context)!.settings.arguments! as RulaTimeline;

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
                                      'Good',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  } else if (value == 0.5) {
                                    return const Text(
                                      'Higher Risk',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  } else if (value == 1) {
                                    return const Text(
                                      'Bad',
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

    paint.color = Colors.green.withValues(alpha: 0.2);

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
