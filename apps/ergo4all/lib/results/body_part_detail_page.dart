import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BodyPartDetailPage extends StatelessWidget {
  const BodyPartDetailPage({
    required this.bodyPart,
    required this.color,
    required this.timelineColors,
    required this.timelineValues,
    super.key,
  });

  final String bodyPart;
  final Color color;
  final List<Color> timelineColors;
  final List<double> timelineValues;

  @override
  Widget build(BuildContext context) {
    // Unique text for each body part
    final bodyPartTexts = <String, Map<String, String>>{
      'Upper Arm': {
        'issue': 'The upper arm was often raised above shoulder level.',
        'risk': 'This increases the risk of rotator cuff injuries.',
        'fix': 'Try keeping your upper arm below shoulder height during tasks.',
      },
      'Lower Arm': {
        'issue':
            'The lower arm was flexed at an extreme angle for long periods.',
        'risk': 'This posture may lead to repetitive strain injuries.',
        'fix':
            'Adjust the workstation to keep your lower arms in a neutral position.',
      },
      'Trunk': {
        'issue': 'The trunk was bent forward excessively.',
        'risk': 'This posture can strain the lower back, causing disc issues.',
        'fix': 'Use a chair with lumbar support and avoid leaning forward.',
      },
      'Neck': {
        'issue': 'The neck was bent at a high angle for a prolonged time.',
        'risk': 'This can lead to ligament strain or disc herniation.',
        'fix':
            'Keep your neck aligned with your spine and avoid looking up or down.',
      },
      'Legs': {
        'issue': 'The legs were unsupported or in awkward postures.',
        'risk': 'This can cause fatigue or circulation problems.',
        'fix': 'Use a footrest to support your legs while seated.',
      },
    };

    final texts = bodyPartTexts[bodyPart] ??
        {
          'issue': 'No issue description available.',
          'risk': 'No risk description available.',
          'fix': 'No fix description available.',
        };

    // Declare gridNames outside the widget tree
    final gridLabels = bodyPart != 'Legs' 
        ? ['Improve', 'Check', 'OK']
        : ['Improve', 'OK'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$bodyPart Analysis'),
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Body Part
            Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        bodyPart,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Timeline Visualization

            const Text(
              'Timeline Behavior',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Container(
            //   height: 20,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: Colors.black12),
            //   ),
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       children: List.generate(timelineColors.length, (index) {
            //         return Container(
            //           width: MediaQuery.of(context).size.width /
            //               timelineColors.length, // Proportional width
            //
            //           color: timelineColors[index],
            //         );
            //       }),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 20),

            // Replace the Container widget with this Stack
            // Replace the Stack widget containing CustomPaint with this:
            SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: bodyPart == 'Legs'? 1.0 : 0.5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withValues(alpha: 0.2),
                          strokeWidth: 3,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 0.5,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            var text = ''; // TODO: take this out so that labels are not hardcoded
                            if (value == 0.0) { text = 'OK'; } 
                            else if (value == 0.5 && bodyPart != 'Legs') { text = 'Check'; }
                            else if (value == 1.0) { text = 'Improve'; }
                            return Text(
                                text,
                                style: const TextStyle(fontSize: 14),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: timelineValues.length.toDouble() - 1,
                    minY: 0 - 0.01, // Adjusted to fit the grid
                    maxY: 1 + 0.01, // Adjusted to fit the grid
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          timelineValues.length,
                          (i) => FlSpot(i.toDouble(), timelineValues[i]),
                        ),
                        isCurved: false,
                        gradient: LinearGradient(
                          colors: timelineColors,
                          stops: List.generate(
                            timelineColors.length,
                            (index) => index / (timelineColors.length - 1),
                          ),
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Stack(
            //   children: [
            //     // Y-axis labels
            //     SizedBox(
            //       height: 100,
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: gridLabels
            //           .map((name) => Text(
            //                 name,
            //                 style: const TextStyle(fontSize: 12),
            //               ))
            //           .toList(),
            //       ),
            //     ),
            //     // Timeline visualization
            //     Padding(
            //       padding: const EdgeInsets.only(left: 50), // Add label space
            //       child: SizedBox(
            //         height: 100,
            //         child: CustomPaint(
            //           painter: TimelinePainter(timelineColors, timelineValues, bodyPart),
            //           size: Size(MediaQuery.of(context).size.width - 82, 50), // Adjusted width for padding
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            const SizedBox(height: 20),

            // Issue Section

            const Text(
              'Issue:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              texts['issue']!,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Risk Section

            const Text(
              'Risk:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              texts['risk']!,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Fix Section

            const Text(
              'Fix:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              texts['fix']!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class TimelinePainter extends CustomPainter {
  TimelinePainter(this.colors, this.values, this.bodyPart);

  final List<Color> colors;
  final List<double> values;
  final String bodyPart;

  Color getColorForValue(double value) {
    if (value < 0.33) {
      return const Color.fromARGB(255, 191, 215, 234);
      // return const Color.fromARGB(255, 123, 194, 255); // Blue for good
    } else if (value < 0.66) {
      return const Color.fromARGB(255, 255, 229, 83);
      // return const Color.fromARGB(255, 255, 218, 10); // Yellow for check
    } else {
      return const Color.fromARGB(255, 255, 90, 95);
      // return const Color.fromARGB(255, 220, 50, 32); // Red for improve
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || colors.isEmpty) return;

    // Set color, width and style for grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final gridLines = bodyPart != 'Legs' 
        ? [0.0, 0.5, 1.0]
        : [0.0, 1.0];

    // Draw the grid lines
    for (final y in gridLines) {
      final yPos = size.height * (1 - y);
      canvas.drawLine(
        Offset(0, yPos),
        Offset(size.width, yPos),
        gridPaint,
      );
    }

    // Draw the score line over time
    final paint = Paint()
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final segmentWidth = size.width / (values.length - 1);

    // Start path at first point
    path.moveTo(0, size.height * (1 - values[0]));

    // Draw line through all points
    for (var i = 1; i < values.length; i++) {
      final x = i * segmentWidth;
      final y = size.height * (1 - values[i]);
      path.lineTo(x, y);
    }

    // Create gradient from all colors
    paint.shader = LinearGradient(
      colors: colors,
      stops: List.generate(
          colors.length, (index) => index / (colors.length - 1),
        ),
    ).createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) =>
      colors != oldDelegate.colors || values != oldDelegate.values;
}
