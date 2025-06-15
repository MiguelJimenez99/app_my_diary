// ignore_for_file: use_build_context_synchronously

import 'package:another_flushbar/flushbar.dart';
import 'package:app_my_diary/providers/NoteProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AlertDeleteNote extends StatefulWidget {
  const AlertDeleteNote({super.key, required this.id});

  final String id;

  @override
  State<AlertDeleteNote> createState() => _AlertDeleteNoteState();
}

class _AlertDeleteNoteState extends State<AlertDeleteNote> {
  void _deleteNote() async {
    try {
      Navigator.pop(context);

      final providerNote = Provider.of<NoteProvider>(context, listen: false);
      await providerNote.deleteNoteProvider(widget.id);

      Flushbar(
        message: 'Nota eliminada correctamente',
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(8.0),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.blueGrey.shade500,
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);
    } catch (error) {
      throw Exception('Error al eliminar la nota: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 300,
      child: AlertDialog(
        title: Text(
          'Comfirmar Eliminacion',
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 25, color: Colors.blueGrey[500]),
          ),
        ),
        content: Text(
          'Estas seguro de que quieres eliminar esta nota?',
          style: GoogleFonts.lato(color: Colors.blueGrey[900], fontSize: 15),
        ),
        contentPadding: EdgeInsets.only(top: 10, left: 30, right: 30),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancelar',
              style: GoogleFonts.lato(fontSize: 15, color: Colors.red[400]),
            ),
          ),
          TextButton(
            onPressed: _deleteNote,
            child: Text(
              'Aceptar',
              style: GoogleFonts.lato(fontSize: 15, color: Colors.blueGrey),
            ),
          ),
        ],
      ),
    );
  }
}
