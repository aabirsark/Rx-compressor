import 'dart:typed_data';

import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.file}) : super(key: key);

  final Uint8List file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview"),
      ),
      body: Center(
          child: InteractiveViewer(
        child: Center(child: Image.memory(file)),
        maxScale: 5,
      )),
    );
  }
}
