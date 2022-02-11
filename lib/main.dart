import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:opencv/core/core.dart';

import 'package:tflite/tflite.dart';
// ignore: library_prefixes
import 'package:image/image.dart' as Img;
// ignore: import_of_legacy_library_into_null_safes
import 'package:opencv/opencv.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _gridlst = [];
  ImagePicker picker = ImagePicker();
  late File a;
  Image imageNew = Image.asset("assets/images/contour.png");
  //Image procImage = Image.asset("assets/images/contour.png");
  bool tf = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sudoku",
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          backgroundColor: Color.fromRGBO(66, 28, 82, 1),
          centerTitle: true,
        ),
        body: Card(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          elevation: 4,
          child: Container(
            height: 600,
            width: 400,
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                tf == false
                    ? (Container(
                        height: 420,
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(66, 28, 82, 1), width: 2),
                        ),
                      ))
                    : Container(height: 420, width: 300, child: imageNew),
                Container(
                  height: 70,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Card(
                    elevation: 4,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.camera,
                              size: 40,
                            ),
                            onPressed: fromCamera,
                            color: const Color.fromRGBO(66, 28, 82, 1),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.select_all,
                              color: Color.fromRGBO(66, 28, 82, 1),
                              size: 40,
                            ),
                            onPressed: _bottomSheet,
                            color: const Color.fromRGBO(66, 28, 82, 1),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.collections,
                              size: 40,
                            ),
                            onPressed: fromGallery,
                            color: const Color.fromRGBO(66, 28, 82, 1),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fromGallery() async {
    tf = true;
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    a = File(image.path);
    Image b = await convertFileToImage(a);
    setState(() {
      imageNew = b;
    });
  }

  void fromCamera() async {
    tf = true;
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    a = File(image.path);
    Image b = await convertFileToImage(a);
    setState(() {
      imageNew = b;
    });
  }

  void _bottomSheet() async {
    //await _sudokuScanner();
    _gridlst = await splitImage(a);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: const Color(0xff757575),
            child: Container(
              height: 1000,
              child: _gridlst[0],
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
            ),
          );
        });
  }

  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);
    return image;
  }

/*
  Future<void> _sudokuScanner() async {
    tf = true;
    // ignore: unused_local_variable

    dynamic img = await ImgProc.threshold(
        await a.readAsBytes(), 80, 255, ImgProc.adaptiveThreshGaussianC);

/*
    
    dynamic img = await ImgProc.blur(
        await a.readAsBytes(), [45, 45], [20, 30], Core.borderReflect);
    dynamic img =
        await ImgProc.pyrMeanShiftFiltering(await a.readAsBytes(), 10, 15);
    dynamic img = await ImgProc.resize(
        await a.readAsBytes(), [50, 50], 0, 0, ImgProc.interArea);
        */

    setState(() {
      procImage = Image.memory(img);
    });
  }
*/
  Future<List<Image>> splitImage(File f) async {
    List<int> bytes = await f.readAsBytes();
    // convert image to image from image package
    Img.Image? image = Img.decodeImage(bytes);

    int x = 0, y = 0;
    int width = (image!.width / 9).round();
    int height = (image.height / 9).round();

    // split image to parts
    // ignore: deprecated_member_use
    List<Img.Image> parts = <Img.Image>[];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        parts.add(Img.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    // convert image from image package to Image Widget to display
    List<Image> output = <Image>[];
    // ignore: deprecated_member_use

    for (Img.Image img in parts) {
      output.add(Image.memory(Img.encodeJpg(img) as Uint8List));
    }

    return output;
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
