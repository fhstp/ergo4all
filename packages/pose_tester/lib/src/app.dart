import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_tester/src/angle_display.dart';
import 'package:pose_tester/src/temp_asset.dart';
import 'package:pose_tester/src/test_image.dart';
import 'package:share_plus/share_plus.dart';

class AnglePage extends StatelessWidget {
  const AnglePage({
    super.key,
    required this.currentAngles,
  });

  final Option<PoseAngles> currentAngles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Angles",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 10),
        if (currentAngles case Some(value: final angles))
          AngleDisplay(angles: angles),
      ],
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

  void selectImageWithName(String name) async {
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(child: Text("Images")),
              ...imageNames.map((name) => ListTile(
                    onTap: () {
                      selectImageWithName(name);
                    },
                    selected: Some(name) == selectedImageName,
                    title: Text(name),
                  ))
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
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
              ),
              SizedBox(height: 20),
              Expanded(
                  child: switch (pageIndex) {
                0 => AnglePage(currentAngles: currentAngles),
                _ => Placeholder()
              }),
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
