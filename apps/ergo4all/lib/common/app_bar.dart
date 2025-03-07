import 'package:common_ui/common_ui.dart';
import 'package:ergo4all/common/custom_images.dart';
import 'package:flutter/material.dart';

/// Makes an [AppBar] widget with the custom styles for this app. This inculdes having the given [title]. It also has the Ergo4All icon in it unless disabled by setting [withIcon] to false.
AppBar makeCustomAppBar({required String title, bool withIcon = true}) {
  return AppBar(
    leading: withIcon
        ? const Padding(
            padding: EdgeInsets.all(smallSpace),
            child: Image(image: CustomImages.iconWhite),
          )
        : null,
    title: Text(title),
    centerTitle: true,
  );
}
