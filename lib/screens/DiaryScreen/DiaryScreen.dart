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
        color: Color.fromRGBO(251, 248, 246, 1),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Mi Diario',
                      style: GoogleFonts.lato(
                        color: Colors.blueGrey[900],
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 4, bottom: 8),
                    child: Text(
                      'Mis pensamientos más secretos',
                      style: GoogleFonts.lato(
                        color: Colors.blueGrey[400],
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(thickness: 1.2, color: Colors.blueGrey[100]),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 170,
                    child: Material(
                      color: Colors.transparent,
                      child: FutureBuilder<List<Diary>>(
                        future: _futureActivities,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueGrey,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: GoogleFonts.lato(
                                  color: Colors.red,
                                  fontSize: 17,
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            final activities = snapshot.data!;
                            if (activities.isEmpty) {
                              return Center(
                                child: Text(
                                  'No hay actividades',
                                  style: GoogleFonts.lato(
                                    color: Colors.blueGrey,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: activities.length,
                              itemBuilder: (context, index) {
                                final activity = activities[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => InfoDiaryScreen(
                                                diary: activity,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 6,
                                      color: Color.fromRGBO(210, 224, 238, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 18,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  activity.date.substring(
                                                    0,
                                                    10,
                                                  ),
                                                  style: GoogleFonts.lato(
                                                    color: Colors.blueGrey[700],
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Row(
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
                                                                style: GoogleFonts.lato(
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
                                                        color: Colors.red[400],
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
                                                        color:
                                                            Colors
                                                                .blueGrey[400],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              activity.title,
                                              style: GoogleFonts.lato(
                                                color: Colors.blueGrey[900],
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey[100],
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Text(
                                                activity.mood,
                                                style: GoogleFonts.lato(
                                                  color: Colors.blueGrey[800],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              activity.description,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: GoogleFonts.lato(
                                                color: Colors.blueGrey[900],
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                style: GoogleFonts.lato(
                                  color: Colors.blueGrey,
                                  fontSize: 18,
                                ),
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
                    color: Colors.blueGrey[700],
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
                      if (result == true) {
                        setState(() {
                          _refreshDiary();
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
