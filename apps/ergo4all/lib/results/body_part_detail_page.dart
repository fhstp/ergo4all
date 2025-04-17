import 'package:flutter/material.dart';

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
              'Timeline Behavior New',
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

            Container(
              height: 50, // Increased height to better show the line variation
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: CustomPaint(
                painter: TimelinePainter(timelineColors, timelineValues),
                size: Size(MediaQuery.of(context).size.width - 32, 50),
              ),
            ),

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
  final List<Color> colors;
  final List<double> values; // Add this line to store y-values

  TimelinePainter(this.colors, this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || colors.isEmpty) return;

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
      final y = size.height * (1 - values[i]); // Invert y since 0 is at top
      path.lineTo(x, y);
    }

    // Create gradient from all colors
    paint.shader = LinearGradient(
      colors: colors,
      stops: List.generate(colors.length,
              (index) => index / (colors.length - 1)
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
