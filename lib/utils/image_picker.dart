import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sudoku/constants/constants.dart';
import 'package:sudoku/utils/file_to_image.dart';

ImagePicker picker = ImagePicker();
// bool imageStatus = false;

// late File imageNew;

Future fromGallery() async {
  Data.imageStatus = true;
  final image = await picker.pickImage(source: ImageSource.gallery);
  if (image == null) return null;
  // return File(image!.path);
  Data.imageNew = File(image.path);
  Data.convertedImage = await convertFileToImage(Data.imageNew);
  print('ImagePicker = ${Data.imageNew}');
  print('ImagePicker = ${Data.convertedImage}');
  // Image b = await convertFileToImage(a); imageNew
  // setState(() {
  //   imageNewimageNew = File(image.path);
  // });
}

Future fromCamera() async {
  Data.imageStatus = true;
  final image = await picker.pickImage(source: ImageSource.camera);
  if (image == null) return null;
  // return File(image!.path);
  Data.imageNew = File(image.path);
  Data.convertedImage = await convertFileToImage(Data.imageNew);
  print('ImagePicker = ${Data.imageNew}');
  print('ImagePicker = ${Data.convertedImage}');
  return;
  // Image b = await convertFileToImage(a);
  // setState(() {
  //   imageNew = b;
  // });
}
