import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_tester/src/map_display.dart';
import 'package:pose_tester/src/rula_score_display.dart';
import 'package:pose_tester/src/score_sheet.dart';
import 'package:pose_tester/src/temp_asset.dart';
import 'package:pose_tester/src/test_image.dart';
import 'package:rula/rula.dart';
import 'package:share_plus/share_plus.dart';

class Page extends StatelessWidget {
  final String title;
  final Widget? body;

  const Page({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 10),
          Expanded(child: SingleChildScrollView(child: body))
        ],
      ),
    );
  }
}

class AnglePage extends StatelessWidget {
  const AnglePage({
    super.key,
    required this.currentAngles,
  });

  final Option<PoseAngles> currentAngles;

  @override
  Widget build(BuildContext context) {
    return Page(
        title: "Angles",
        body: switch (currentAngles) {
          Some(value: final angles) => MapDisplay(
              map: angles,
              formatKey: (keyAngle) => keyAngle.name,
              formatValue: (degrees) => "${degrees.toInt()}°"),
          _ => null
        });
  }
}

class ScorePage extends StatefulWidget {
  final Option<PoseAngles> angles;

  const ScorePage({super.key, required this.angles});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  Option<ScoreSheet> currentSheet = none();

  void refreshSheet() async {
    setState(() {
      currentSheet = none();
    });

    await Future.value(Null);

    widget.angles.match(() {}, (angles) {
      final rulaSheet = rulaSheetFromAngles(angles);
      setState(() {
        currentSheet = Some(ScoreSheet(
            upperArm: calcUpperArmScore(rulaSheet),
            lowerArm: calcLowerArmScore(rulaSheet),
            neck: calcNeckScore(rulaSheet),
            trunk: calcTrukScore(rulaSheet),
            leg: calcLegScore(rulaSheet),
            full: calcFullRulaScore(rulaSheet)));
      });
    });
  }

  @override
  void didUpdateWidget(covariant ScorePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    refreshSheet();
  }

  @override
  void initState() {
    super.initState();
    refreshSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
        title: "Score",
        body: currentSheet.match(
            () => CircularProgressIndicator(),
            (sheet) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RulaScoreDisplay(
                        label: "Full", score: sheet.full, maxScore: 7),
                    RulaScoreDisplay(
                        label: "Upper arm", score: sheet.upperArm, maxScore: 6),
                    RulaScoreDisplay(
                        label: "Lower arm", score: sheet.lowerArm, maxScore: 3),
                    RulaScoreDisplay(
                        label: "Neck", score: sheet.neck, maxScore: 6),
                    RulaScoreDisplay(
                        label: "Trunk", score: sheet.trunk, maxScore: 6),
                    RulaScoreDisplay(
                        label: "Leg", score: sheet.trunk, maxScore: 2),
                  ],
                )));
  }
}

class Pose3DDisplay extends StatelessWidget {
  const Pose3DDisplay({
    super.key,
    required this.selectedImage,
    required this.selectedPose,
  });

  final Option<TestImage> selectedImage;
  final Option<Pose> selectedPose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 0, maxHeight: 300),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (selectedImage case Some(value: final image)) ...[
              Image(
                image: image.asset,
                fit: BoxFit.fitHeight,
              ),
              if (selectedPose case Some(value: final pose))
                Positioned.fill(
                  child: CustomPaint(
                      painter: PosePainter(
                          pose: pose,
                          imageSize: Size(image.width.toDouble(),
                              image.height.toDouble()))),
                )
            ],
          ],
        ),
      ),
    );
  }
}

class PoseTesterApp extends StatefulWidget {
  const PoseTesterApp({super.key});

  @override
  State<PoseTesterApp> createState() => _PoseTesterAppState();
}

class _PoseTesterAppState extends State<PoseTesterApp> {
  IList<String> imageNames = const IList.empty();
  Option<String> selectedImageName = none();
  Option<TestImage> selectedImage = none();
  Option<Pose> selectedPose = none();
  Option<PoseAngles> currentAngles = none();
  int pageIndex = 0;

  String assetKeyFor(String imageName) => 'assets/test_images/$imageName';

  void updatePoseForImage(String imageName) async {
    setState(() {
      selectedPose = none();
      currentAngles = none();
    });

    var assetKey = assetKeyFor(imageName);

    final imageFile = await makeTempFileForAsset(assetKey);
    try {
      final input = PoseDetectInput.fromFile(imageFile);
      final pose = (await detectPose(input))!;
      final normalized = normalizePose(pose);
      final (coronal, sagittal) = projectOnAnatomicalPlanes(normalized);
      final angles = calculateAngles(normalized, coronal, sagittal);

      setState(() {
        selectedPose = Some(pose);
        currentAngles = Some(angles);
      });
    } finally {
      await imageFile.delete();
    }
  }

  void selectImageWithName(String? name) async {
    if (name == null) {
      setState(() {
        selectedImageName = none();
        selectedImage = none();
        selectedPose = none();
        currentAngles = none();
      });
      return;
    }

    var assetKey = assetKeyFor(name);

    setState(() {
      selectedImageName = Some(name);
    });

    final image = await TestImage.loadFromAsset(assetKey);
    setState(() {
      selectedImage = Some(image);
    });

    updatePoseForImage(name);
  }

  void loadImages() async {
    final Map<String, dynamic> manifestContent =
        jsonDecode(await rootBundle.loadString('AssetManifest.json'));

    setState(() {
      imageNames = manifestContent.keys
          .where((it) => it.contains("test_image"))
          .map((it) => it.split("/").last)
          .toIList();
    });

    if (imageNames.isNotEmpty) selectImageWithName(imageNames.first);
  }

  @override
  void initState() {
    super.initState();

    void doInitialIO() async {
      await startPoseDetection(PoseDetectMode.static);
      loadImages();
    }

    doInitialIO();
  }

  @override
  void dispose() {
    super.dispose();

    void doFinalIO() async {
      await stopPoseDetection();
    }

    doFinalIO();
  }

  void sharePose(BuildContext context, Pose pose) async {
    final poseText = pose.mapTo((point, landmark) {
      final pos = posOf(landmark);
      return "${point.name}: ${pos.x}, ${pos.y}, ${pos.z}";
    }).join("\n");

    final shareResult = await Share.share(poseText, subject: "Exported pose");

    if (shareResult.status == ShareResultStatus.unavailable &&
        context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Share failed")));
    }
  }

  void switchToPage(int newIndex) {
    setState(() {
      pageIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pose tester",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pose tester"),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: InkWell(
                        onTap: switch (selectedPose) {
                          Some(value: final pose) => () {
                              sharePose(context, pose);
                            },
                          _ => null
                        },
                        child: Text("Share pose"),
                      ))
                    ])
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Pose3DDisplay(
                  selectedImage: selectedImage, selectedPose: selectedPose),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("Select image"),
                  SizedBox(width: 20),
                  DropdownButton<String>(
                      items: imageNames
                          .map((name) => DropdownMenuItem<String>(
                                value: name,
                                child: Text(name),
                              ))
                          .toList(),
                      value: selectedImageName.toNullable(),
                      onChanged: selectImageWithName),
                ],
              ),
              SizedBox(height: 20),
              switch (pageIndex) {
                0 => AnglePage(currentAngles: currentAngles),
                1 => ScorePage(angles: currentAngles),
                _ => Placeholder()
              },
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.text_rotation_angledown), label: "Angles"),
            BottomNavigationBarItem(
                icon: Icon(Icons.scoreboard), label: "Scores"),
          ],
          currentIndex: pageIndex,
          onTap: switchToPage,
        ),
      ),
    );
  }
}
