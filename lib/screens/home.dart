import 'package:ergo4all/io/video.dart';
import 'package:ergo4all/screens/analysis.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  final Future<XFile?> Function() tryGetVideo;

  const HomeScreen({super.key, this.tryGetVideo = tryGetVideoFromGallery});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    void analyzeVideo(XFile videoFile) {
      navigator.push(MaterialPageRoute(builder: (_) => const AnalysisScreen()));
    }

    void trySelectVideoForAnalysis() async {
      final videoFile = await tryGetVideo();
      if (videoFile == null) return;

      analyzeVideo(videoFile);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Placeholder(),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              key: const Key("upload"),
              onPressed: trySelectVideoForAnalysis,
              icon: const Icon(Icons.upload)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        ],
      )),
    );
  }
}
