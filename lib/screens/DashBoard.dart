import 'dart:developer';

import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/providers/DiaryProvider.dart';
import 'package:app_my_diary/providers/PhotoProvider.dart';
import 'package:app_my_diary/providers/UserProvider.dart';
import 'package:app_my_diary/providers/weather_provider.dart';
import 'package:app_my_diary/screens/DiaryScreen/InfoDiaryScreen.dart';
import 'package:app_my_diary/screens/FavoriteScreen/FavoritesScreen.dart';
import 'package:app_my_diary/screens/GalleryScreens/InfoPhotoScreen.dart';
import 'package:app_my_diary/screens/NotesScreens/NotesScreen.dart';
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

  @override
  void initState() {
    super.initState();
    _loadDataUser();
    _loadDataPhoto();
    Future.microtask(() {
      Provider.of<WeatherProvider>(context, listen: false).loadWeather();
      _loadDataDiary();
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

      if (diaryProvider.diary!.isEmpty) {
        log('No tienes entradas registrada');
      } else {
        setState(() {
          _diary = diaryProvider.diary!.first;
        });
      }
    } catch (e) {
      throw Exception('Error al cargar los datos del diario: $e');
    }
  }

  Future<void> _loadDataPhoto() async {
    try {
      final photoProvider = Provider.of<PhotoProvider>(context, listen: false);
      await photoProvider.fetchPhoto();

      if (photoProvider.photo.isEmpty) {
        log('No tienes fotos guardadas');
      } else {
        setState(() {
          _photo = photoProvider.photo.first;
        });
      }
    } catch (e) {
      throw Exception('Error al cargar la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final diaryProvider =
        Provider.of<DiaryProvider>(context, listen: false).diary;
    final listDiaryEmpty = diaryProvider == null || diaryProvider.isEmpty;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadDataPhoto,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: 795,
            decoration: BoxDecoration(color: Color.fromRGBO(251, 248, 246, 1)),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(251, 248, 246, 1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _user == null
                          ? Container(
                            width: 180,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )
                          : Text(
                            'Hola, ${_user!.name}!',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.blueGrey[800],
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          '¿Cómo te sientes hoy?',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.blueGrey[400],
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10),
                        child: Divider(
                          thickness: 1.2,
                          color: Colors.blueGrey[100],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Tarjeta de Última Nota
                            listDiaryEmpty
                                ? Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey.withOpacity(
                                          0.10,
                                        ),
                                        blurRadius: 16,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.book,
                                              color: Colors.blueGrey[400],
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Último Diario',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  color: Colors.blueGrey[400],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Divider(
                                          color: Colors.blueGrey[100],
                                        ),
                                      ),
                                      Text(
                                        'No tienes entradas registradas',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.blueGrey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : GestureDetector(
                                  onTap: () async {
                                    Diary entranceDiary;
                                    final diaryProvider =
                                        Provider.of<DiaryProvider>(
                                          context,
                                          listen: false,
                                        );
                                    await diaryProvider.fetchDiary();
                                    entranceDiary = diaryProvider.diary!.first;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => InfoDiaryScreen(
                                              diary: entranceDiary,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey.withOpacity(
                                            0.10,
                                          ),
                                          blurRadius: 16,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.book,
                                                color: Colors.blueGrey[400],
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Última nota',
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    color: Colors.blueGrey[400],
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            child: Divider(
                                              color: Colors.blueGrey[100],
                                            ),
                                          ),
                                          _diary == null
                                              ? Container(
                                                width: 100,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              )
                                              : Text(
                                                _diary!.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    color: Colors.blueGrey[900],
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                          const SizedBox(height: 6),
                                          Flexible(
                                            child:
                                                _diary == null
                                                    ? Container(
                                                      width: 100,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    )
                                                    : Text(
                                                      _diary!.description,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          color:
                                                              Colors
                                                                  .blueGrey[800],
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            // Tarjeta de Último Recuerdo
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Color.fromRGBO(219, 225, 231, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey.withOpacity(0.10),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.photo,
                                          color: Colors.blueGrey[400],
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Último recuerdo',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color: Colors.blueGrey[400],
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Divider(
                                        color: Colors.blueGrey[100],
                                      ),
                                    ),
                                    Expanded(
                                      child:
                                          _photo == null
                                              ? Container(
                                                width: double.infinity,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.blueGrey[200],
                                                  size: 40,
                                                ),
                                              )
                                              : InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => InfoPhotoScreen(
                                                            photos:
                                                                _photo != null
                                                                    ? [_photo!]
                                                                    : [],
                                                            index: 0,
                                                            dataPhoto: _photo!,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: Image.network(
                                                    _photo!.url,
                                                    width: double.infinity,
                                                    height: 90,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Icon(
                                                            Icons.broken_image,
                                                            color:
                                                                Colors
                                                                    .blueGrey[200],
                                                            size: 40,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 320, left: 30, right: 30),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(210, 224, 238, 1),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.10),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child:
                        weatherProvider.isLoading
                            ? Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
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
                  padding: const EdgeInsets.only(top: 500, left: 10, right: 10),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 520, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Mas Opciones',

                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              color: Colors.blueGrey,
                              elevation: 5,
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0),
                                  ),
                                  onPressed: () async {
                                    final user =
                                        Provider.of<UserProvider>(
                                          context,
                                          listen: false,
                                        ).user;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                NotesScreen(user: user!),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Mis Notas',
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: Colors.blueGrey,
                              elevation: 5,
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0),
                                  ),
                                  onPressed: () {
                                    final user =
                                        Provider.of<UserProvider>(
                                          context,
                                          listen: false,
                                        ).user;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => MyFavoriteItemsScreen(
                                              user: user!,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Favoritos',
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
