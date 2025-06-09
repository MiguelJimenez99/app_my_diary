import 'package:another_flushbar/flushbar.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/providers/NoteProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



class MyDialogForm extends StatefulWidget {
  const MyDialogForm({super.key, required this.user});

  final User user;
  @override
  State<MyDialogForm> createState() => _MyDialogFormState();
}

class _MyDialogFormState extends State<MyDialogForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerDescription = TextEditingController();

  void createNote() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        await Provider.of<NoteProvider>(
          context,
          listen: false,
        ).createNoteProvider(
          _controllerDescription.text.trim(),
          widget.user.id,
        );

        setState(() {
          _controllerDescription.clear();
        });

        Flushbar(
          message: 'Nota agregada correctamente',
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(8.0),
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.blueGrey,
          flushbarPosition: FlushbarPosition.BOTTOM,
        ).show(context);
      } else {
        Flushbar(
          message: 'Error al agregar la nota',
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(8.0),
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.blueGrey,
          flushbarPosition: FlushbarPosition.BOTTOM,
        ).show(context);
      }
    } catch (error) {
      throw Exception('Error interno: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                'Nueva Nota',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 30,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: GoogleFonts.lato(color: Colors.blueGrey[400]),
                prefixIcon: Icon(Icons.notes, color: Colors.blueGrey),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 5,
              controller: _controllerDescription,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El campo no puede ir vacio';
                }
                return null;
              },
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Color.fromRGBO(210, 224, 238, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.blueGrey),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text(
                      'Cancelar',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    icon: Icon(Icons.close, color: Colors.blueGrey),
                  ),
                  SizedBox(width: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.blueGrey,
                    ),
                    onPressed: createNote,
                    label: Text(
                      'Guardar',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.white, fontSize: 15),
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
    );
  }
}