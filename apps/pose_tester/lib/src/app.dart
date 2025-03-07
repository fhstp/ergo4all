// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:common_ui/theme/theme.dart';
import 'package:common_ui/widgets/paint_on_image.dart';
import 'package:flutter/material.dart' hide Page, ProgressIndicator;
import 'package:fpdart/fpdart.dart' hide State;
import 'package:image_picker/image_picker.dart';
import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_detect/pose_detect.dart';
import 'package:pose_tester/src/angle_page.dart';
import 'package:pose_tester/src/image_file.dart';
import 'package:pose_tester/src/pose2d_page.dart';
import 'package:pose_tester/src/score_page.dart';
import 'package:pose_transforming/normalization.dart';
import 'package:pose_transforming/pose_2d.dart';
import 'package:pose_vis/pose_vis.dart';
import 'package:share_plus/share_plus.dart';

class Pose3DDisplay extends StatelessWidget {
  const Pose3DDisplay({
    super.key,
    required this.selectedImage,
    required this.selectedPose,
  });

  final Option<ImageFile> selectedImage;
  final Option<Pose> selectedPose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 0, maxHeight: 300),
        child: selectedImage.match(
          () => null,
          (image) => PaintOnWidget(
            base: Image.memory(
              image.bytes,
              fit: BoxFit.fitHeight,
            ),
            painter: selectedPose
                .map(
                  (pose) => Pose3dPainter(
                    pose: pose,
                    imageSize: Size(
                      image.width.toDouble(),
                      image.height.toDouble(),
                    ),
                  ),
                )
                .toNullable(),
          ),
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

@immutable
class PoseData {
  final Pose worldPose;
  final NormalizedPose normalizedPose;
  final PoseAngles angles;

  const PoseData({
    required this.worldPose,
    required this.normalizedPose,
    required this.angles,
  });
}

class _PoseTesterAppState extends State<PoseTesterApp> {
  Option<ImageFile> selectedImage = none();
  Option<PoseData> currentPoseData = none();
  bool show3dPose = true;
  int pageIndex = 0;

  String assetKeyFor(String imageName) => 'assets/test_images/$imageName';

  void updatePoseForImage(ImageFile imageFile) async {
    setState(() {
      currentPoseData = none();
    });

    final input = PoseDetectInput.fromFile(imageFile.file);
    final pose = (await detectPose(input))!;
    final normalized = normalizePose(pose);
    final coronal = make2dCoronalPose(normalized);
    final sagittal = make2dSagittalPose(normalized);
    final transverse = make2dTransversePose(normalized);
    final angles = calculateAngles(normalized, coronal, sagittal, transverse);

    setState(() {
      currentPoseData = Some(PoseData(
        worldPose: pose,
        normalizedPose: normalized,
        angles: angles,
      ));
    });
  }

  void selectImage(Option<ImageFile> imageFile) async {
    setState(() {
      selectedImage = none();
      currentPoseData = none();
    });

    setState(() {
      selectedImage = imageFile;
    });

    selectedImage.match(() {}, updatePoseForImage);
  }

  @override
  void initState() {
    super.initState();

    void doInitialIO() async {
      await startPoseDetection(PoseDetectMode.static);
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

  void chooseImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;

    final imageFile = await ImageFile.loadFrom(xFile.path);
    selectImage(some(imageFile));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pose tester",
      theme: ergo4allTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pose tester"),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: InkWell(
                        onTap: switch (currentPoseData) {
                          Some(value: final pose) => () {
                              sharePose(context, pose.worldPose);
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
                  selectedPose: show3dPose
                      ? currentPoseData.map((it) => it.worldPose)
                      : none(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: chooseImage, child: Text("Select image")),
              if (selectedImage.isSome()) ...[
                SizedBox(height: 20),
                Expanded(
                  child: switch (pageIndex) {
                    0 => AnglePage(
                        currentAngles: currentPoseData.map((it) => it.angles),
                      ),
                    1 => ScorePage(
                        angles: currentPoseData.map((it) => it.angles),
                      ),
                    2 => Pose2dPage(
                        title: "Sagittal",
                        makePose2d: make2dSagittalPose,
                        normalizedPose:
                            currentPoseData.map((it) => it.normalizedPose),
                      ),
                    3 => Pose2dPage(
                        title: "Coronal",
                        makePose2d: make2dCoronalPose,
                        normalizedPose:
                            currentPoseData.map((it) => it.normalizedPose),
                      ),
                    4 => Pose2dPage(
                        title: "Transverse",
                        makePose2d: make2dTransversePose,
                        normalizedPose:
                            currentPoseData.map((it) => it.normalizedPose),
                      ),
                    _ => Placeholder()
                  },
                ),
              ]
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
