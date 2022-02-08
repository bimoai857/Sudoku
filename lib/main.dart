// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

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
  List _outputs = [];
  ImagePicker picker = ImagePicker();
  File? a;
  Image imageNew = Image.asset("assets/images/contour.png");
  Image procImage = Image.asset("assets/images/contour.png");
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
    Image b = await convertFileToImage(a!);
    setState(() {
      imageNew = b;
      procImage = b;
    });
  }

  void fromCamera() async {
    tf = true;
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    File a = File(image.path);
    Image b = await convertFileToImage(a);
    setState(() {
      imageNew = b;
      procImage = b;
    });
  }

  void _bottomSheet() async {
    _sudokuScanner;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: const Color(0xff757575),
            child: Container(
              height: 600,
              child: imageNew,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
            ),
          );
        });
  }

  Future<File?> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final File? file = File('${(await getTemporaryDirectory()).path}/$path');
    await file!.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);
    return image;
  }

  Future<void> _sudokuScanner() async {
    File? file = a;
    const heightImg = 5;
    const widthImg = 5;
    tf = true;
    dynamic img = await ImgProc.resize(await file!.readAsBytes(),
        [heightImg, widthImg], 0, 0, ImgProc.interArea);

    setState(() {
      procImage = Image.memory(img);
    });
  }
}
