import 'package:another_flushbar/flushbar.dart';
import 'package:app_my_diary/class/NoteClass.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/providers/NoteProvider.dart';
import 'package:app_my_diary/providers/UserProvider.dart';
import 'package:app_my_diary/screens/NotesScreens/NotesScreen.dart';
import 'package:app_my_diary/widgets/dialogs/DialogFavoriteNote.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NoteFavoriteScreen extends StatelessWidget {
  const NoteFavoriteScreen({
    super.key,
    required this.user,
    required List<Note> favoriteNotes,
  }) : _favoriteNotes = favoriteNotes;

  final User? user;
  final List<Note> _favoriteNotes;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notas Favoritas',
                        style: GoogleFonts.lato(
                          fontSize: 25,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotesScreen(user: user!),
                            ),
                          );
                        },
                        label: Text(
                          'Ir a notas',
                          style: GoogleFonts.lato(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 260,
              child:
                  _favoriteNotes.isEmpty
                      ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blueGrey[300],
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
                                        (context) => NotesScreen(user: user!),
                                  ),
                                );
                              },
                              label: Text(
                                'Ir a mis notas',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_circle_right_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No tienes notas favoritas',
                              style: GoogleFonts.lato(
                                fontSize: 17,
                                color: Colors.blueGrey[900],
                              ),
                            ),
                          ),
                        ],
                      )
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _favoriteNotes.length,
                        itemBuilder: (context, index) {
                          final note = _favoriteNotes[index];
                          return SizedBox(
                            width: 200,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 4,
                                right: 4,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  final provider = Provider.of<NoteProvider>(
                                    context,
                                    listen: false,
                                  );
                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel:
                                        MaterialLocalizations.of(
                                          context,
                                        ).modalBarrierDismissLabel,
                                    barrierColor: Colors.black54,
                                    transitionDuration: const Duration(
                                      milliseconds: 300,
                                    ), // Duración de la animación
                                    pageBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                    ) {
                                      return InfoNoteFAvorite(
                                        provider: provider,
                                        note: note,
                                      );
                                    },
                                    transitionBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ScaleTransition(
                                          scale: CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutBack,
                                          ),
                                          child: child,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  color: Colors.grey[200],
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            top: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Fecha',
                                                style: GoogleFonts.lato(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  try {
                                                    await Provider.of<
                                                      NoteProvider
                                                    >(
                                                      context,
                                                      listen: false,
                                                    ).favoriteNoteProvider(
                                                      note.id,
                                                    );
                                                    Flushbar(
                                                      message:
                                                          'Nota eliminada de favoritos',
                                                      duration: Duration(
                                                        seconds: 2,
                                                      ),
                                                      margin: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      backgroundColor:
                                                          Colors.red.shade300,
                                                      flushbarPosition:
                                                          FlushbarPosition
                                                              .BOTTOM,
                                                    ).show(context);
                                                  } catch (error) {
                                                    throw Exception(
                                                      'Error al eliminar la nota de favoritos: $error',
                                                    );
                                                  }
                                                },

                                                icon: Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Icon(
                                          Icons.calendar_month,
                                          size: 30,
                                          color: Colors.blueGrey[800],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          note.date.substring(0, 10),
                                          style: GoogleFonts.lato(
                                            fontSize: 20,
                                            color: Colors.blueGrey[800],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child: Text(
                                            'Descripcion',
                                            style: GoogleFonts.lato(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Text(
                                          note.description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: GoogleFonts.lato(
                                            color: Colors.blueGrey[800],
                                          ),
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
          ],
        );
      },
    );
  }
}
