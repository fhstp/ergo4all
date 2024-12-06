import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart' hide State;

class PoseTesterApp extends StatefulWidget {
  const PoseTesterApp({super.key});

  @override
  State<PoseTesterApp> createState() => _PoseTesterAppState();
}

class _PoseTesterAppState extends State<PoseTesterApp> {
  IList<String> imageNames = const IList.empty();
  Option<String> selectedImageName = none();
  Option<AssetImage> selectedImage = none();

  void selectImageWithName(String name) async {
    setState(() {
      selectedImageName = Some(name);
      selectedImage = Some(AssetImage('assets/test_images/$name'));
    });
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

    loadImages();
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: selectedImage.match(
                    () => Placeholder(), (it) => Image(image: it))),
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
            )
          ],
        ),
      ),
    );
  }
}
