import 'dart:io';

import 'package:compresser/app/utils.dart';
import 'package:compresser/meta/results.dart';
import 'package:compresser/model/home_model.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _heightController;
  late TextEditingController _widthController;
  late TextEditingController _qualityController;

  @override
  void initState() {
    _heightController = TextEditingController(text: "1280");
    _widthController = TextEditingController(text: "720");
    _qualityController = TextEditingController(text: "90");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compresser"),
      ),
      bottomNavigationBar: Container(
        height: 55,
        margin: const EdgeInsets.only(top: 10, bottom: 12),
        child: Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              if (context.read<ImagePickerProvider>().file != null) {
                if (_heightController.text.isNotEmpty ||
                    _widthController.text.isNotEmpty ||
                    _qualityController.text.isNotEmpty) {
                  try {
                    int height = int.parse(_heightController.text);
                    int width = int.parse(_widthController.text);
                    int quality = int.parse(_qualityController.text);
                    context
                        .read<ImagePickerProvider>()
                        .changeCompressingValue();

                    var compressedFile = await Utils.testCompressFile(
                        context.read<ImagePickerProvider>().file!,
                        height,
                        width,
                        quality);
                    context
                        .read<ImagePickerProvider>()
                        .changeCompressingValue();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            file: compressedFile,
                          ),
                        ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Bad entry led to an ERROR"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Bad entry"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("All Fields are required"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10)),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !context.watch<ImagePickerProvider>().isCompressing
                    ? const Text(
                        "Compress",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DimensionInputField(
                    controller: _heightController,
                    label: "min height",
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  DimensionInputField(
                      controller: _widthController, label: "min width"),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            QualityInputField(controller: _qualityController),
            const SizedBox(
              height: 30,
            ),
            const ImagePickerField()
          ]),
        ),
      ),
    );
  }
}

class DimensionInputField extends StatelessWidget {
  const DimensionInputField(
      {Key? key, required this.controller, required this.label})
      : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
              color: Colors.white10, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextFormField(
              onChanged: (value) {
                try {
                  int intVal = int.parse(value);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  if (intVal > 7000) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter a small value"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Bad entry"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }
}

class QualityInputField extends StatelessWidget {
  const QualityInputField({Key? key, required this.controller})
      : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Quality",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              color: Colors.white10, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextFormField(
              onChanged: (value) {
                try {
                  int intVal = int.parse(value);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  if (intVal > 100) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Too Big Value"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Bad entry"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }
}

class ImagePickerField extends StatelessWidget {
  const ImagePickerField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.watch<ImagePickerProvider>().file == null
              ? "Pick Image"
              : "Image Selected",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          height: 5,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            XFile? pickedFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              context
                  .read<ImagePickerProvider>()
                  .setFile(File(pickedFile.path));
            }
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.78,
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: context.watch<ImagePickerProvider>().file == null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        CupertinoIcons.add,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Pick Image")
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Image Selected")
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
