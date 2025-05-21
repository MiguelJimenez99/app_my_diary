import 'dart:convert';

import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/providers/DiaryProvider.dart';
import 'package:app_my_diary/providers/PhotoProvider.dart';
import 'package:app_my_diary/providers/UserProvider.dart';
import 'package:app_my_diary/providers/weather_provider.dart';
import 'package:app_my_diary/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  User? _user;
  Photo? _photo;
  Diary? _diary;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDataUser();
    _loadDataDiary();
    _loadDataPhoto();
    Future.microtask(() {
      Provider.of<WeatherProvider>(context, listen: false).loadWeather();
    });
  }

  void _loadDataUser() async {
    try {
      final userData = Provider.of<UserProvider>(context, listen: false);
      await userData.fetchUser();

      setState(() {
        _user = userData.user;
      });
    } catch (e) {
      throw Exception('Error al obtener los datos del usuario $e');
    }
  }

  void _loadDataDiary() async {
    try {
      final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
      await diaryProvider.fetchDiary();

      setState(() {
        _diary = diaryProvider.diary!.first;
        print(_diary!.title);
      });
    } catch (e) {
      throw Exception('Error al cargar los datos del diario: $e');
    }
  }

  void _loadDataPhoto() async {
    try {
      final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      await photoProvider.fetchPhoto();

      setState(() {
        _photo = photoProvider.photo!.last;
        if (_photo!.url == null) {
          print('Cargando...');
        } else {
          print(_photo!.url);
        }
      });
    } catch (e) {
      throw Exception('Error al cargar la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return SafeArea(
      child: Stack(
        children: [
          Container(decoration: BoxDecoration(color: Color(0xFF0F172A))),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _user == null
                    ? Text('Cargando...', style: TextStyle(color: Colors.white))
                    : Text(
                      'Hola, ${_user!.name}!',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),

                Center(
                  child: Text(
                    '¿Como te sientes hoy?',
                    style: TextStyle(color: Colors.grey, fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 160,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ultima nota',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              _diary == null
                                  ? Text(
                                    'Cargando...',
                                    style: TextStyle(color: Colors.white),
                                  )
                                  : Text(
                                    _diary!.title,
                                    style: TextStyle(color: Colors.white),
                                  ),

                              _diary == null
                                  ? Text('Cargando...')
                                  : Text(
                                    _diary!.mood,
                                    style: TextStyle(color: Colors.white),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            children: [
                              Text(
                                'Ultimo recuerdo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),

                              _photo == null
                                  ? Text(
                                    'Cargando...',
                                    style: TextStyle(color: Colors.white),
                                  )
                                  : SizedBox(
                                    width: 80,
                                    height: 40,
                                    child: Image.network(
                                      _photo!.url,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child:
                weatherProvider.isLoading
                    ? CircularProgressIndicator()
                    : weatherProvider.error != null
                    ? Text(
                      'Error: ${weatherProvider.error}',
                      style: TextStyle(color: Colors.white),
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (weatherProvider.icon != null)
                          Image.network(
                            'https://openweathermap.org/img/wn/${weatherProvider.icon}@2x.png',
                            width: 100,
                            height: 100,
                            color: Colors.white,
                          ),
                        Text(
                          '${weatherProvider.temperature}°C',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          weatherProvider.description ?? '',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                        Text(
                          weatherProvider.city ?? '',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                        Text(
                          weatherProvider.country ?? '',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            weatherProvider.loadWeather();
                          },
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
