import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sudoku/constants/constants.dart';

ImagePicker picker = ImagePicker();
// bool imageStatus = false;

// late File imageNew;

Future fromGallery() async {
  Data.imageStatus = true;
  final image = await picker.pickImage(source: ImageSource.gallery);
  if (image == null) return null;
  // return File(image!.path);
  Data.imageNew = File(image.path);
  print('ImagePicker = ${Data.imageNew}');
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
  print('ImagePicker = ${Data.imageNew}');
  return;
  // Image b = await convertFileToImage(a);
  // setState(() {
  //   imageNew = b;
  // });
}
