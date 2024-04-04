import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  final ImagePicker _picker = ImagePicker();

  Future<String> getImageFromGallery(Color cropUiColor) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    var croppedPath =
        await cropImage(await compressImage(image!.path, image), cropUiColor);
    return croppedPath;
  }

  Future<String> getImageFromCamera(Color cropUiColor) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
    );

    var croppedPath = await cropImage(
        await compressImage(image?.path ?? '', image), cropUiColor);
    return croppedPath;
  }

  Future<String> cropImage(String imagePath, Color cropUiColor) async {
    try {
      CroppedFile? croppedFile =
          await ImageCropper().cropImage(sourcePath: imagePath, uiSettings: [
        AndroidUiSettings(
          toolbarColor: cropUiColor,
          toolbarTitle: 'Crop Image',
          toolbarWidgetColor: Colors.white,
        ),
      ]);
      return croppedFile!.path;
    } catch (e) {
      throw ImageCroppingException();
    }
  }

  Future<String> compressImage(String imgPath, XFile? file) async {
    try {
      if (file == null) return '';
      var size = await file.length();
      if (size <= 350000) return file.path;
      int compressPercentage = ((350000 / size) * 100).toInt();
      if (compressPercentage < 10) {
        throw ImageTooLargeException('Image couldn\'t be compressed');
      }
      final lastIndex = file.path.lastIndexOf(RegExp(r'.jp'));
      final splitted = imgPath.substring(0, (lastIndex));
      final outPath = '${splitted}_out${imgPath.substring(lastIndex)}';

      file = await FlutterImageCompress.compressAndGetFile(imgPath, outPath,
          quality: compressPercentage);
      return file?.path ?? '';
    } on Exception catch (e) {
      throw ImageCompressException(e.toString());
    }
  }
}

class ImageTooLargeException implements Exception {
  final String message;

  ImageTooLargeException(this.message);

  @override
  String toString() => message;
}

class ImageCroppingException implements Exception {}

class ImageCompressException implements Exception {
  final String message;

  ImageCompressException(this.message);
}
