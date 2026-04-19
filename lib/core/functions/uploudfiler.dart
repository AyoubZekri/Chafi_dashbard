import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

Future<File> compressTo2MB(File file) async {
  const maxSize = 2 * 1024 * 1024;

  img.Image? image = img.decodeImage(await file.readAsBytes());
  if (image == null) return file;

  int quality = 90;
  List<int> encoded = img.encodeJpg(image, quality: quality);

  while (encoded.length > maxSize && quality > 10) {
    quality -= 10;
    encoded = img.encodeJpg(image, quality: quality);
  }

  final newFile = File(file.path)..writeAsBytesSync(encoded);

  return newFile;
}

// imageuploadcamera() async {
//   final XFile? file = await ImagePicker().pickImage(
//     source: ImageSource.camera,
//     imageQuality: 90,
//   );
//   if (file != null) {
//     return File(file.path);
//   } else {
//     return null;
//   }
// }

Future<File?> fileuploadGallery([bool isvg = true]) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: isvg
        ? ["svg", "SVG"]
        : ["png", "PNG", "jpg", "JPG", "jpeg", "gif"],
  );

  if (result == null) return null;

  File file = File(result.files.single.path!);

  // SVG ما يتضغطش
  if (isvg) return file;

  // تحقق من الحجم
  const maxSize = 2 * 1024 * 1024; // 2MB

  if (await file.length() <= maxSize) {
    return file; // عادي
  }

  // ضغط الصورة
  return await compressTo2MB(file);
}

Future<FilePickerResult?> fileuploadGallerys([bool isvg = false]) async {
  return await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: isvg
        ? ["svg", "SVG"]
        : ["png", "PNG", "jpg", "JPG", "jpeg", "gif", "pdf", 'doc', 'docx'],
  );
}

