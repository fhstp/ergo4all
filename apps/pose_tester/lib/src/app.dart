import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart' hide Page, ProgressIndicator;
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_tester/src/angle_page.dart';
import 'package:pose_tester/src/page.dart';
import 'package:pose_tester/src/progress_indicator.dart';
import 'package:pose_tester/src/score_page.dart';
import 'package:pose_tester/src/temp_asset.dart';
import 'package:pose_tester/src/test_image.dart';
import 'package:pose_vis/pose_vis.dart';
import 'package:share_plus/share_plus.dart';

class Pose2dPage extends StatefulWidget {
  final String title;
  final Option<NormalizedPose> normalizedPose;
  final Pose2d Function(NormalizedPose) makePose2d;

  const Pose2dPage(
      {super.key,
      required this.normalizedPose,
      required this.makePose2d,
      required this.title});

  @override
  State<Pose2dPage> createState() => _Pose2dPageState();
}

class _Pose2dPageState extends State<Pose2dPage> {
  Option<Pose2d> pose = none();

  void recalculatePose() {
    setState(() {
      pose = none();
    });

    widget.normalizedPose.match(() {}, (normalizedPose) {
      setState(() {
        pose = Some(widget.makePose2d(normalizedPose));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    recalculatePose();
  }

  @override
  void didUpdateWidget(covariant Pose2dPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    recalculatePose();
  }

  @override
  Widget build(BuildContext context) {
    return Page(
        title: widget.title,
        body: pose.match(
            () => ProgressIndicator(),
            (pose) => Expanded(
                child: CustomPaint(painter: Pose2dPainter(pose: pose)))));
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
                      painter: Pose3dPainter(
                          pose: pose,
                          imageSize: Size(image.width.toDouble(),
                              image.height.toDouble()))),
                )
            ] else
              ProgressIndicator()
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
  Option<NormalizedPose> normalizedPose = none();
  Option<PoseAngles> currentAngles = none();
  bool show3dPose = true;
  int pageIndex = 0;

  String assetKeyFor(String imageName) => 'assets/test_images/$imageName';

  void updatePoseForImage(String imageName) async {
    setState(() {
      selectedPose = none();
      normalizedPose = none();
      currentAngles = none();
    });

    var assetKey = assetKeyFor(imageName);

    final imageFile = await makeTempFileForAsset(assetKey);
    try {
      final input = PoseDetectInput.fromFile(imageFile);
      final pose = (await detectPose(input))!;
      final normalized = normalizePose(pose);
      final coronal = make2dCoronalPose(normalized);
      final sagittal = make2dSagittalPose(normalized);
      final transverse = make2dTransversePose(normalized);
      final angles = calculateAngles(normalized, coronal, sagittal, transverse);

      setState(() {
        selectedPose = Some(pose);
        normalizedPose = Some(normalized);
        currentAngles = Some(angles);
      });
    } finally {
      await imageFile.delete();
    }
  }

  void selectImageWithName(String? name) async {
    setState(() {
      selectedImage = none();
      selectedPose = none();
      normalizedPose = none();
      currentAngles = none();
    });

    if (name == null) {
      setState(() {
        selectedImageName = none();
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    show3dPose = !show3dPose;
                  });
                },
                child: Pose3DDisplay(
                  selectedImage: selectedImage,
                  selectedPose: show3dPose ? selectedPose : none(),
                ),
              ),
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
              Expanded(
                child: switch (pageIndex) {
                  0 => AnglePage(currentAngles: currentAngles),
                  1 => ScorePage(angles: currentAngles),
                  2 => Pose2dPage(
                      title: "Sagittal",
                      makePose2d: make2dSagittalPose,
                      normalizedPose: normalizedPose,
                    ),
                  3 => Pose2dPage(
                      title: "Coronal",
                      makePose2d: make2dCoronalPose,
                      normalizedPose: normalizedPose,
                    ),
                  4 => Pose2dPage(
                      title: "Transverse",
                      makePose2d: make2dTransversePose,
                      normalizedPose: normalizedPose,
                    ),
                  _ => Placeholder()
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.text_rotation_angledown), label: "Angles"),
            BottomNavigationBarItem(
                icon: Icon(Icons.scoreboard), label: "Scores"),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_walk), label: "Sagittal"),
            BottomNavigationBarItem(
                icon: Icon(Icons.accessibility_new), label: "Coronal"),
            BottomNavigationBarItem(
                icon: Icon(Icons.circle), label: "Transverse"),
          ],
          currentIndex: pageIndex,
          onTap: switchToPage,
        ),
      ),
    );
  }
}
