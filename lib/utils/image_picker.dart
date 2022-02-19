import 'dart:io';
import 'package:image_picker/image_picker.dart';

ImagePicker picker = ImagePicker();
bool imageStatus = false;

// late File imageNew;

fromGallery() async {
  imageStatus = true;
  final image = await picker.pickImage(source: ImageSource.gallery);
  if (image == null) return null;
  return File(image.path);

  // Image b = await convertFileToImage(a); imageNew
  // setState(() {
  //   imageNewimageNew = File(image.path);
  // });
}

fromCamera() async {
  imageStatus = true;
  final image = await picker.pickImage(source: ImageSource.camera);
  if (image == null) return null;
  return File(image.path);
  // Image b = await convertFileToImage(a);
  // setState(() {
  //   imageNew = b;
  // });
}
