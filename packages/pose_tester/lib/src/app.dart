import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:pose/pose.dart';
import 'package:pose_tester/src/angle_display.dart';
import 'package:pose_tester/src/temp_asset.dart';

class PoseTesterApp extends StatefulWidget {
  const PoseTesterApp({super.key});

  @override
  State<PoseTesterApp> createState() => _PoseTesterAppState();
}

class _PoseTesterAppState extends State<PoseTesterApp> {
  IList<String> imageNames = const IList.empty();
  Option<String> selectedImageName = none();
  Option<AssetImage> selectedImage = none();
  Option<Pose> selectedPose = none();
  Option<PoseAngles> currentAngles = none();

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
      final (coronal, sagittal) = projectOnAnatomicalPlanes(pose);
      final angles = calculateAngles(pose, coronal, sagittal);

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
      selectedImage = Some(AssetImage(assetKey));
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

  void copyPoseToClipboard(Pose pose) async {
    final poseText = pose.mapTo((point, landmark) {
      final pos = posOf(landmark);
      return "${point.name}: ${pos.x}, ${pos.y}, ${pos.z}";
    }).join("\n");
    await Clipboard.setData(ClipboardData(text: poseText));

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Copied pose")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final highlightedButtonStyle = ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(200, 200, 240, 1));

    return MaterialApp(
      title: "Pose tester",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pose tester"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (selectedImage case Some(value: final image))
                      Image(
                        image: image,
                        fit: BoxFit.fitHeight,
                      ),
                    if (selectedPose case Some(value: final pose))
                      Positioned.fill(
                        child: CustomPaint(
                            painter: PosePainter(
                                pose: pose, imageSize: Size(240, 320))),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: imageNames
                      .map((name) => ElevatedButton(
                            onPressed: () {
                              selectImageWithName(name);
                            },
                            style: Some(name) == selectedImageName
                                ? highlightedButtonStyle
                                : null,
                            child: Text(name),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 10),
              if (currentAngles case Some(value: final angles))
                Expanded(child: AngleDisplay(angles: angles)),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    if (selectedPose case Some(value: final pose))
                      IconButton.filled(
                          onPressed: () {
                            copyPoseToClipboard(pose);
                          },
                          icon: Icon(Icons.copy))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
