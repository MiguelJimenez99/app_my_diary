// ignore_for_file: use_build_context_synchronously

import 'package:app_my_diary/providers/DiaryProvider.dart';
import 'package:flutter/material.dart';
import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/screens/DiaryScreen/DiaryFormScreen.dart';
import 'package:app_my_diary/screens/DiaryScreen/EditDiaryScreen.dart';
import 'package:app_my_diary/screens/DiaryScreen/InfoDiaryScreen.dart';
import 'package:app_my_diary/services/DiaryService.dart';
import 'package:app_my_diary/services/UserServices.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  UserService userService = UserService();
  DiaryServices diaryServices = DiaryServices();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<DiaryProvider>(context, listen: false).fetchDiary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final diaryProvider = context.watch<DiaryProvider>();
    final diaries = diaryProvider.diary;
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
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Text(
                          'Mis pensamientos más secretos',
                          style: GoogleFonts.lato(
                            color: Colors.blueGrey[400],
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 70),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          onPressed: diaryProvider.fetchDiary,
                          child: Text(
                            'Actualizar',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 235,
                      child: Material(
                        color: Colors.transparent,
                        child:
                            diaryProvider.isLoading
                                ? Center(child: CircularProgressIndicator())
                                : diaries == null || diaries.isEmpty
                                ? Center(
                                  child: Text(
                                    'No hay actividades registradas',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: diaries.length,
                                  itemBuilder: (context, index) {
                                    final diary = diaries[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => InfoDiaryScreen(
                                                    diary: diary,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 6,
                                          color: Color.fromRGBO(
                                            210,
                                            224,
                                            238,
                                            1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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
                                                      diary.date.substring(
                                                        0,
                                                        10,
                                                      ),
                                                      style: GoogleFonts.lato(
                                                        color:
                                                            Colors
                                                                .blueGrey[700],
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                                    content:
                                                                        const Text(
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
                                                            if (confirm ==
                                                                true) {
                                                              await Provider.of<
                                                                DiaryProvider
                                                              >(
                                                                context,
                                                                listen: false,
                                                              ).deleteDiary(
                                                                diary.id,
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
                                                                      fontSize:
                                                                          17,
                                                                    ),
                                                                  ),
                                                                  duration:
                                                                      Duration(
                                                                        seconds:
                                                                            2,
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
                                                            }
                                                          },
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color:
                                                                Colors.red[400],
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => EditDiaryScreen(
                                                                      diary:
                                                                          diary,
                                                                    ),
                                                              ),
                                                            );
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
                                                  diary.title,
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
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    diary.mood,
                                                    style: GoogleFonts.lato(
                                                      color:
                                                          Colors.blueGrey[800],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  diary.description,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                ),
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
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final userId = await userService.getDataUser();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DiaryFormScreen(user: userId),
                        ),
                      );
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
