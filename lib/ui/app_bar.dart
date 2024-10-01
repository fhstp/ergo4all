import 'package:flutter/material.dart';

/// Makes an [AppBar] widget with the custom styles for this app.
/// This inculdes having the given [title].
AppBar makeCustomAppBar({required String title}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
  );
}
