import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

ImagePicker picker = ImagePicker();
bool imageStatus = false;

late File imageNew;
fromGallery() async {
  imageStatus = true;
  final image = await picker.pickImage(source: ImageSource.gallery);
  if (image == null) return null;
  imageNew = File(image.path);
  // Image b = await convertFileToImage(a); imageNew
  // setState(() {
  //   imageNew
  // });
}

void fromCamera() async {
  imageStatus = true;
  final image = await picker.pickImage(source: ImageSource.camera);
  if (image == null) return null;
  imageNew = File(image.path);
  // Image b = await convertFileToImage(a);
  // setState(() {
  //   imageNew = b;
  // });
}
