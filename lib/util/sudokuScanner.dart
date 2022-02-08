import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import 'package:opencv/opencv.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

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
