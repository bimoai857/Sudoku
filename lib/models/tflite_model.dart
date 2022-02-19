import 'dart:io';
import 'package:tflite/tflite.dart';

loadModel() async {
  await Tflite.loadModel(
      model: "assets/model.tflite", labels: "assets/labels.txt");
}

classifyImage(File image) async {
  var output = await Tflite.runModelOnImage(
    path: image.path,
    numResults: 1,
    threshold: 0.0,
    imageMean: 127.5,
    imageStd: 127.5,
  );
  print(output);
  return output;
}
