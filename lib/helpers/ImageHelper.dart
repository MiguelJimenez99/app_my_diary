import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile> compressImage(XFile file) async {
  final dir = await getTemporaryDirectory();
  final targetPath = path.join(
    dir.absolute.path,
    '${DateTime.now().millisecondsSinceEpoch}.jpg',
  );

  final compressedFile = await FlutterImageCompress.compressAndGetFile(
    file.path,
    targetPath,
    quality: 70,
    format: CompressFormat.jpeg,
  );

  if (compressedFile == null) throw Exception('Error al comprimir la imagen');
  return XFile(compressedFile.path); // ✅ aquí lo conviertes correctamente
}
