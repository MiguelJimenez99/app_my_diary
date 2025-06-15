import 'dart:convert';
import 'dart:io';
import 'package:app_my_diary/helpers/ImageHelper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoService {
  //https://back-my-diary-v2.onrender.com
  //static String baseUrl = 'https://back-my-diary-v2.onrender.com';
 static String baseUrl = 'http://192.168.1.42:3000';


  List<Photo> _photos = [];

  // funcion para obtener todas las fotos del usuario

  Future<List<Photo>> getUserPhotos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token vencido o invalido');
      }

      final url = Uri.parse('$baseUrl/api/user/photos/getPhotos');
      final response = await http.get(url, headers: {'authorization': token});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['posts'] == null || data['posts'] is! List) {
          return [];
        }

        final photoList = data['posts'] as List;
        _photos = photoList.map((item) => Photo.fromJson(item)).toList();

        return _photos;
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener las fotos del usuario');
    }
  }

  // Funcion para guardar las fotos en la base de datos

  Future<void> postPhotoUser({
    required XFile imageFile,
    String? description,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token vencido o invalido');
      }

      // ✅ Comprimir imagen
      final compressedImage = await compressImage(imageFile);

      final url = Uri.parse('$baseUrl/api/user/photos/newPhoto');
      final request =
          http.MultipartRequest('POST', url)
            ..headers['authorization'] = token
            ..fields['description'] = description ?? '';

      // ✅ Detectar tipo MIME del archivo comprimido
      final mimeType = lookupMimeType(compressedImage.path) ?? 'image/jpeg';
      final mimeSplit = mimeType.split('/');

      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          compressedImage.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final data = jsonDecode(resBody);
        return data['message'];
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al subir la foto: $e');
    }
  }

  // funcion para actualizar estado de la foto

  Future<bool> favoriteUserPhoto(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token invalido o vencido');
      }

      final url = Uri.parse('$baseUrl/api/user/photos/$id/favorite');
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json', 'authorization': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'];
      } else {
        throw Exception('Error al actuaizar el estado: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error en el servidor');
    }
  }

  // Funcion para eliminar la foto de la base de datos Nota: Falta implementar tambien eliminarla de cloudinary

  Future<void> delPhoto(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token vencido o invalido ');
      }

      final url = Uri.parse('$baseUrl/api/user/photos/delPhoto/$id');
      final response = await http.delete(
        url,
        headers: {'authorization': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'];
      } else {
        throw Exception('Error al eliminar la imagen: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en el servidor: $e');
    }
  }

  // Funcion para compartir la foto en formato imagen

  Future<void> SharePhotoFromUrl(String url) async {
    try {
      // 1- descargo la imagen
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Error al descargar imagen');
      }

      // 2- obtengo directorio temporal

      final temDir = await getTemporaryDirectory();

      if (!(await temDir.exists())) {
        await temDir.create(recursive: true);
      }

      // Crear archivo temporal
      final filePath =
          '${temDir.path}/shared_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);

      // Compartir usando share_plus
      await Share.shareXFiles([XFile(file.path)], text: '¡Mira esta foto!');
    } catch (e) {
      throw Exception('Error al compartir la imagen: $e');
    }
  }
}
