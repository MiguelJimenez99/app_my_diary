import 'package:flutter/material.dart';
import '../services/WeatherService.dart';
import '../helpers/LocationHelper.dart';

class WeatherProvider extends ChangeNotifier {
  String? _temperature;
  String? _description;
  String? _iconCode;
  String? _city;
  String? _country;
  bool _isLoading = false;
  String? _error;

  String? get temperature => _temperature;
  String? get description => _description;
  String? get icon => _iconCode;
  String? get city => _city;
  String? get country => _country;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await LocationHelper.getCurrentLocation();
      final weatherData = await WeatherService().getWeather(
        position.latitude,
        position.longitude,
      );

      _temperature = weatherData['main']['temp'].toString();
      _description = weatherData['weather'][0]['description'];
      _iconCode = weatherData['weather'][0]['icon'];
      _city = weatherData['name'];
      _country = weatherData['sys']['country'];
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
