// ignore_for_file: use_build_context_synchronously

import 'package:another_flushbar/flushbar.dart';
import 'package:app_my_diary/class/NoteClass.dart';
import 'package:app_my_diary/providers/NoteProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class InfoNoteScreenDialog extends StatefulWidget {
  const InfoNoteScreenDialog({
    super.key,
    required this.noteProvider,
    required this.note,
  });

  final NoteProvider noteProvider;
  final Note note;

  @override
  State<InfoNoteScreenDialog> createState() => _InfoNoteScreenDialogState();
}

class _InfoNoteScreenDialogState extends State<InfoNoteScreenDialog> {
  late TextEditingController _controllerDescription;
  bool isEditing = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controllerDescription = TextEditingController(
      text: widget.note.description,
    );
  }

  void _favoriteNote() async {
    try {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      await noteProvider.favoriteNoteProvider(widget.note.id);

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (error) {
      throw Exception('Error al actualizar el estado: $error');
    }
  }

  void _editNoteUser() async {
    try {
      if (_controllerDescription.text == "" ||
          _controllerDescription.text.isEmpty) {
        Flushbar(
          message: 'No se pueden enviar datos vacios',
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(8.0),
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.red.shade300,
          flushbarPosition: FlushbarPosition.BOTTOM,
        ).show(context);
      } else {
        await Provider.of<NoteProvider>(
          context,
          listen: false,
        ).updateNoteProvider(
          _controllerDescription.text.trim(),
          widget.note.id,
        );
        setState(() {
          isEditing = false;
        });
        Flushbar(
          message: 'Nota editada correctamente',
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(8.0),
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.blueGrey.shade500,
          flushbarPosition: FlushbarPosition.BOTTOM,
        ).show(context);
      }
    } catch (error) {
      throw Exception('Error al editar la nota $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final notes = noteProvider.notes.firstWhere(
      (note) => note.id == widget.note.id,
      orElse: () => widget.note,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Center(
        child: Container(
          width: double.infinity,
          height: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Center(
                  child: Text(
                    'Detalles',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 25,
                        decoration: TextDecoration.none,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: _favoriteNote,
                      icon: Icon(
                        notes.isFavorite ?? false
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            notes.isFavorite ?? false
                                ? Colors.red
                                : Colors.grey,
                        size: 25,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Share.share(widget.note.description);
                        },
                        icon: Icon(
                          Icons.share,
                          color: Colors.blueGrey,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.blueGrey[500]),
                    SizedBox(width: 10),
                    Text(
                      'Fecha:',
                      style: GoogleFonts.lato(
                        color: Colors.blueGrey[500],
                        fontSize: 17,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[600],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    notes.date.substring(0, 10),
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  'Mi nota:',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 17,
                      color: Colors.blueGrey[500],
                    ),
                  ),
                ),
              ),
              isEditing
                  ? Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 30,
                      right: 30,
                    ),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey[50],
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade50,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade50,
                            ),
                          ),
                        ),
                        controller: _controllerDescription,
                        autofocus: true,
                        maxLines: 4,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 17,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                      ),
                    ),
                  )
                  : widget.note.description.isEmpty
                  ? Text('No hay datos')
                  : Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: Text(
                      notes.description,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 25,
                          decoration: TextDecoration.none,
                          color: Colors.blueGrey[700],
                        ),
                      ),
                    ),
                  ),

              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[200],
                        side: BorderSide(color: Colors.blueGrey),
                      ),
                      onPressed: () {
                        setState(() {
                          if (isEditing) {
                            _controllerDescription.text =
                                widget
                                    .note
                                    .description; // Resetear si se cancela
                          }
                          isEditing = !isEditing;
                        });
                      },
                      label: Text(
                        isEditing ? 'Cancelar' : 'Editar',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 17),
                          color: Colors.blueGrey,
                        ),
                      ),
                      icon: Icon(
                        isEditing ? Icons.close : Icons.edit,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(width: 30),
                    if (isEditing)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        onPressed: _editNoteUser,
                        label: Text(
                          'Guardar',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        icon: Icon(Icons.save, color: Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
