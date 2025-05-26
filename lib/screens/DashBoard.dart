import 'dart:convert';

import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/providers/DiaryProvider.dart';
import 'package:app_my_diary/providers/PhotoProvider.dart';
import 'package:app_my_diary/providers/UserProvider.dart';
import 'package:app_my_diary/providers/weather_provider.dart';
import 'package:app_my_diary/screens/DiaryScreen/InfoDiaryScreen.dart';
import 'package:app_my_diary/screens/GalleryScreens/InfoPhotoScreen.dart';
import 'package:app_my_diary/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Widget shimmeringEffect({
    required double width,
    required double height,
    required BorderRadius borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius,
      ),
      child: const SizedBox(),
    );
  }

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
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(251, 248, 246, 1)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _user == null
                    ? shimmeringEffect(
                      width: 300,
                      height: 40,
                      borderRadius: BorderRadius.circular(20),
                    )
                    : Text(
                      'Hola, ${_user!.name}!',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                Center(
                  child: Text(
                    '¿Como te sientes hoy?',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey, fontSize: 25),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Diary entranceDiary;

                          final diaryProvider = Provider.of<DiaryProvider>(
                            context,
                            listen: false,
                          );
                          await diaryProvider.fetchDiary();

                          entranceDiary = diaryProvider.diary!.first;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      InfoDiaryScreen(diary: entranceDiary),
                            ),
                          );
                        },
                        child: Container(
                          width: 180,
                          height: 170,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(
                                  0,
                                  3,
                                ), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.book, color: Colors.black54),
                                      SizedBox(width: 10),
                                      Text(
                                        'Ultimo diario',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Divider(),
                                ),
                                _diary == null
                                    ? Center(
                                      child: shimmeringEffect(
                                        width: 100,
                                        height: 20,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    )
                                    : Text(
                                      _diary!.title,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                  ),
                                  child:
                                      _diary == null
                                          ? shimmeringEffect(
                                            width: 100,
                                            height: 20,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          )
                                          : Text(
                                            _diary!.description,
                                            maxLines: 3,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 180,
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(
                                  0,
                                  3,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.photo, color: Colors.black54),
                                      SizedBox(width: 10),
                                      Text(
                                        'Ultimo recuerdo',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Divider(),
                                ),
                                _photo == null
                                    ? shimmeringEffect(
                                      width: 100,
                                      height: 30,
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                    : Center(
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  _photo!.url,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 290, left: 30, right: 30),
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Color.fromRGBO(210, 224, 238, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child:
                  weatherProvider.isLoading
                      ? Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                      : weatherProvider.error != null
                      ? Text(
                        'Error: ${weatherProvider.error}',
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 17,
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (weatherProvider.icon != null)
                            Image.network(
                              'https://openweathermap.org/img/wn/${weatherProvider.icon}@2x.png',
                              width: 100,
                              height: 100,
                              color: Colors.white,
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Text(
                                  '${weatherProvider.temperature}°C',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  weatherProvider.description ?? '',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        weatherProvider.city ?? '',
                                        style: GoogleFonts.lato(
                                          color: Colors.black54,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        weatherProvider.country ?? '',
                                        style: GoogleFonts.lato(
                                          color: Colors.black54,
                                          fontSize: 20,
                                        ),
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
                          ),
                        ],
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 450, left: 10, right: 10),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 470, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mas Opciones',
                  style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25)),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Card(
                    elevation: 5,
                    child: SizedBox(
                      width: 370,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                        onPressed: () {
                          print('Mis notas');
                        },
                        child: Text(
                          'Mis Notas',
                          style: GoogleFonts.lato(
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Card(
                    elevation: 5,
                    child: SizedBox(
                      width: 370,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                        onPressed: () {
                          print('Mis favoritos');
                        },
                        child: Text(
                          'Favoritos',
                          style: GoogleFonts.lato(
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
