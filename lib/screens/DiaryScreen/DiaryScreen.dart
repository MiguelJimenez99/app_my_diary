import 'package:flutter/material.dart';
import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/screens/DiaryScreen/DiaryFormScreen.dart';
import 'package:app_my_diary/screens/DiaryScreen/EditDiaryScreen.dart';
import 'package:app_my_diary/screens/DiaryScreen/InfoDiaryScreen.dart';
import 'package:app_my_diary/services/DiaryService.dart';
import 'package:app_my_diary/services/UserServices.dart';
import 'package:google_fonts/google_fonts.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late Future<List<Diary>> _futureActivities;

  UserService userService = UserService();
  DiaryServices diaryServices = DiaryServices();

  @override
  void initState() {
    super.initState();
    _refreshDiary(); // Call refreshDiary() herF
  }

  void _refreshDiary() {
    setState(() {
      _futureActivities = diaryServices.getDataActivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(251, 248, 246, 1)),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        'Mi Diario',
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    height: MediaQuery.of(context).size.height - 170,
                    decoration: BoxDecoration(),
                    child: Material(
                      color: Color.fromRGBO(251, 248, 246, 1),
                      child: FutureBuilder<List<Diary>>(
                        future: _futureActivities,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            final activities = snapshot.data!;
                            return ListView.builder(
                              itemCount: activities.length,
                              itemBuilder: (context, index) {
                                final activity = activities[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      final diary = activities[index];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  InfoDiaryScreen(diary: diary),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 5,
                                      color: Color.fromRGBO(210, 224, 238, 1),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 20,
                                            ),
                                            child: Text(
                                              activity.date.substring(0, 10),
                                              style: GoogleFonts.lato(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Text(
                                              activity.title,
                                              style: GoogleFonts.lato(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 10,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Text(
                                                activity.mood,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 20,
                                                ),
                                                child: SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    activity.description,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40,
                                                width: 100,

                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        final confirm = await showDialog<
                                                          bool
                                                        >(
                                                          context: context,
                                                          builder:
                                                              (
                                                                context,
                                                              ) => AlertDialog(
                                                                title: const Text(
                                                                  'Confirmar eliminación',
                                                                ),
                                                                content: const Text(
                                                                  '¿Estás seguro de que quieres eliminar este diario?',
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () => Navigator.pop(
                                                                          context,
                                                                          false,
                                                                        ),
                                                                    child: const Text(
                                                                      'Cancelar',
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () => Navigator.pop(
                                                                          context,
                                                                          true,
                                                                        ),
                                                                    child: const Text(
                                                                      'Eliminar',
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                        );

                                                        if (confirm == true) {
                                                          await diaryServices
                                                              .deleteDiary(
                                                                activity.id,
                                                              );
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Eliminado correctamente',
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                              duration:
                                                                  Duration(
                                                                    seconds: 2,
                                                                  ),
                                                              backgroundColor:
                                                                  Color.fromRGBO(
                                                                    53,
                                                                    49,
                                                                    149,
                                                                    1,
                                                                  ),
                                                            ),
                                                          );
                                                          await Future.delayed(
                                                            Duration(
                                                              seconds: 1,
                                                            ),
                                                          );
                                                          setState(() {
                                                            _refreshDiary();
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        final result =
                                                            await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => EditDiaryScreen(
                                                                      diary:
                                                                          activity,
                                                                    ),
                                                              ),
                                                            );

                                                        if (result == true) {
                                                          setState(() {
                                                            _refreshDiary();
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color: Colors.lightBlue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                'No hay actividades',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 25, right: 10, bottom: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final userId = await userService.getDataUser();

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DiaryFormScreen(user: userId),
                        ),
                      );

                      // Si se creó una nueva actividad, recarga la lista
                      if (result == true) {
                        setState(() {
                          _refreshDiary(); // vuelve a ejecutar el Future
                        });
                      }
                    },
                    icon: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
