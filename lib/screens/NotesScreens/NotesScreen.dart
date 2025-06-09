// ignore_for_file: use_build_context_synchronously, file_names
import 'package:app_my_diary/dialogs/DeleteNoteDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/providers/NoteProvider.dart';
import 'package:app_my_diary/screens/NotesScreens/FormScreenDialog.dart';
import 'package:app_my_diary/screens/NotesScreens/InfoNoteScreenDialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key, required this.user});

  final User user;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<NoteProvider>(context, listen: false).fetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final notesList = noteProvider.notes;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(251, 248, 246, 1),
        centerTitle: true,
        title: Text(
          'Mis Notas',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.blueGrey[900],
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(251, 248, 246, 1),
      body: SafeArea(
        child: Stack(
          children: [
            noteProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : notesList.isEmpty
                ? Text('No hay notas registradas')
                : ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    final note = notesList[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                      ),
                      child: GestureDetector(
                        onTap: () {
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
                              //retorn el showDialog que muestra la informacion de la nota con la opciones de editar o cancelar
                              //para devolver a la vista inicial
                              return InfoNoteScreenDialog(
                                noteProvider: noteProvider,
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
                          elevation: 5,
                          child: ListTile(
                            leading: Icon(
                              Icons.book,
                              color: Colors.blueGrey[800],
                            ),
                            title: Text(
                              note.description,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 17,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              note.date.substring(0, 10),
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel:
                                      MaterialLocalizations.of(
                                        context,
                                      ).modalBarrierDismissLabel,
                                  barrierColor: Colors.black54,
                                  transitionDuration: Duration(
                                    milliseconds: 300,
                                  ),
                                  pageBuilder: (
                                    context,
                                    animation,
                                    secundaryAnimation,
                                  ) {
                                    return AlertDeleteNote(id: note.id);
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
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent.shade100,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  content: MyDialogForm(user: widget.user),
                  backgroundColor: Color.fromRGBO(210, 224, 238, 1),
                ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
