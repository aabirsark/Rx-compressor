import 'dart:typed_data';
import 'dart:ui';

import 'package:compresser/app/utils.dart';
import 'package:compresser/meta/preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key, required this.file}) : super(key: key);

  final Uint8List file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.done,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Image Compressesd",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text("File Size : ${Utils.getFileSize(file.length, 1)}"),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewPage(file: file),
                    ));
              },
              child: const OptionButton(
                  icon: Icons.preview, label: "preview", color: Colors.indigo),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                var result = await Utils.saveFile(file);
                print(result);
              },
              child: const OptionButton(
                  icon: CupertinoIcons.download_circle,
                  label: "save",
                  color: Colors.green),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const OptionButton(
                  icon: CupertinoIcons.return_icon,
                  label: "return",
                  color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton(
      {Key? key, required this.icon, required this.label, required this.color})
      : super(key: key);
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Colors.white10),
          child: Center(
            child: Icon(
              icon,
              color: color,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        )
      ],
    );
  }
}
