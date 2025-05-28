import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = dotenv.env['API_KEY_WEATHER']!;

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    try {
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=es';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener el clima');
      }
    } catch (e) {
      print(e);
      throw Exception('Error $e');
    }
  }
}
