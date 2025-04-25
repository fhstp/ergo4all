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

    const good =  Color.fromARGB(255, 191, 215, 234); // Good (Blue)
    const mid =  Color.fromARGB(255, 255, 229, 83);  // Improve (Yellow)
    const bad =  Color.fromARGB(255, 255, 90, 95);   // Bad (Red)

    // const good =  Color.fromARGB(255, 123, 194, 255); // Good (Blue)
    // const mid =  Color.fromARGB(255, 255, 218, 10);  // Improve (Yellow)
    // const bad =  Color.fromARGB(255, 220, 50, 32);   // Bad (Red)

    final timelineColors = timelineData.map((spot) {
      if (spot.y < 0.33) {
        return good; // Good
      } else if (spot.y < 0.66) {
        return mid; // Improve
      } else {
        return bad; // Bad
      }
    }).toList();

    final timelineValues = timelineData.map((spot) { return spot.y; }).toList();

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

    final lineChartData = IList([
      graphLineFor(calcUpperArmScore, 6),
      graphLineFor(calcLowerArmScore, 3),
      graphLineFor(calcTrukScore, 6),
      graphLineFor(calcNeckScore, 6),
      graphLineFor(calcLegScore, 2),
    ]);

    final heatmapHeight = MediaQuery.of(context).size.width * 0.6;
    final heatmapWidth = MediaQuery.of(context).size.width * 0.85;

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

          Expanded(
            child: Center(
              child: SizedBox(
                width: heatmapWidth, // Adjusted for larger width
                height: heatmapHeight, // Adjusted for a proportional height

                child:  Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: GestureDetector(
                    onTapDown: (details) {
                      // Find row of the bar that was tapped
                      final rowHeight = heatmapHeight / labels.length;
                      final rowIndex = (details.localPosition.dy / rowHeight).floor();
                      if (rowIndex >= 0 && rowIndex < labels.length) {
                        _navigateToBodyPartPage(
                          labels[rowIndex],
                          colors[rowIndex],
                          lineChartData[rowIndex],
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
                        labels: labels, // Add this line
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Color legend
          SizedBox(
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
                        Color.fromARGB(255, 191, 215, 234), // Good (Blue)
                        Color.fromARGB(255, 247, 255, 155),
                        Color.fromARGB(255, 255, 229, 83),  // Mid (Yellow)
                        // Color.fromARGB(255, 255, 162, 89),
                        Color.fromARGB(255, 255, 166, 97),
                        Color.fromARGB(255, 255, 90, 95),   // Bad (Red)
                        // Color.fromARGB(255, 123, 194, 255), // Good (Blue)
                        // Color.fromARGB(255, 255, 218, 10),  // Mid (Yellow)
                        // Color.fromARGB(255, 220, 50, 32),   // Bad (Red)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4), // Space between line and labels
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Neutral', style: TextStyle(fontSize: 14)),
                    // Text('Check', style: TextStyle(fontSize: 14)),
                    Text('Strained', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

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
          const SizedBox(height: 20),

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

  static const good = Color.fromARGB(255, 191, 215, 234); // Blue
  static const goodMid = Color.fromARGB(255, 247, 255, 155); // blue-yellow
  static const mid = Color.fromARGB(255, 255, 229, 83);   // Yellow
  static const midBad = Color.fromARGB(255, 255, 166, 97); // yellow-red
  static const bad = Color.fromARGB(255, 255, 90, 95);    // Red

  // static const good = Color.fromARGB(255, 123, 194, 255); // Blue
  // static const goodMid = Color.fromARGB(255, 181, 205, 147); // blue-yellow
  // static const mid = Color.fromARGB(255, 255, 218, 10);   // Yellow
  // static const midBad = Color.fromARGB(255, 235, 124, 22); // yellow-red
  // static const bad = Color.fromARGB(255, 220, 50, 32);    // Red

  Color getColorForValue(double value) {
    // map between value and color
    if (value < 0.20) {
      return good;
    } else if (value <= 0.40) {
      return goodMid;
    } else if (value <= 0.60) {
      return mid;
    } else if (value <= 0.80) {
      return midBad;
    }
    return bad;
  }

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
      paint.color = getColorForValue(value);

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
