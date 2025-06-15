import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryServices {
  //https://back-my-diary-v2.onrender.com
  //http://192.168.1.42:3000
  //static String baseUrl = 'https://back-my-diary-v2.onrender.com';
   static String baseUrl = 'http://192.168.1.42:3000';

  List<Diary> _activities = [];

  List<Diary> get activities => _activities;

  Future<List<Diary>> getDataActivity() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token vencido o invalido');
      }

      final url = Uri.parse('$baseUrl/api/user/diary/getPost');
      final response = await http.get(url, headers: {'authorization': token});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final diariesList = data['posts'] as List;
        _activities = diariesList.map((item) => Diary.fromJson(item)).toList();
        return _activities;
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener las actividades del usuario');
    }
  }

  Future<String> newPostActivity(
    String title,
    String description,
    String mood,
    String date,
    String userId,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token invalido o vencido');
      }

      final url = Uri.parse('$baseUrl/api/user/diary/newPost');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'authorization': token},
        body: jsonEncode({
          'title': title,
          'description': description,
          'mood': mood,
          'date': date,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'];
      } else {
        throw Exception('Error al registrar la actividad: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al registrar la actividad, $e');
    }
  }

  Future<String> updateDiary(
    String id,
    String title,
    String description,
    String mood,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token expirado o invalid');
      }

      final url = Uri.parse('$baseUrl/api/user/diary/putPost/$id');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json', 'authorization': token},
        body: jsonEncode({
          'title': title,
          'description': description,
          'mood': mood,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'];
      } else {
        throw Exception('Error al actualizar la actividad: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en el servidor: $e');
    }
  }

  Future<void> deleteDiary(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token ivalido o vencido');
      }

      final url = Uri.parse('$baseUrl/api/user/diary/deletePost/$id');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json', 'authorization': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'];
      } else {
        throw Exception('Error al eliminar la actividad: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en el servidor: $e');
    }
  }
}
