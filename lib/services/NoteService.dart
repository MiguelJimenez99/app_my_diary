import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:app_my_diary/class/NoteClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteService {
  static String baseUrl = 'https://back-my-diary-v2.onrender.com';

  List<Note> _notes = [];

  Future<List<Note>> getUserNotes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token vencido o invalido');
      }

      final url = Uri.parse('$baseUrl/api/user/notes/getNotes');
      final response = await http.get(url, headers: {'authorization': token});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final listNotes = data['getNotes'] as List;
        _notes = listNotes.map((note) => Note.fromJson(note)).toList();
        return _notes;
      } else {
        throw Exception('Mensaje: ${response.body}');
      }
    } catch (error) {
      print(error);
      throw Exception('Error en el servidor: $error');
    }
  }

  Future<void> createUserNote(
    String description,
    String userId,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('TOken vencido o invalido');
      }

      final url = Uri.parse('$baseUrl/api/user/notes/createNote');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'authorization': token},
        body: jsonEncode({
          'description': description,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'];
      } else {
        throw Exception('Error al registrar la nueva nota ${response.body}');
      }
    } catch (error) {
      throw Exception('Error en el servidor: $error');
    }
  }
}
