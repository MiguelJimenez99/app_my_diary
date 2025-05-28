import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/providers/DiaryProvider.dart';
import 'package:flutter/material.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/services/DiaryService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DiaryFormScreen extends StatefulWidget {
  const DiaryFormScreen({super.key, required this.user});

  final User user;

  @override
  State<DiaryFormScreen> createState() => _DiaryFormScreenState();
}

class _DiaryFormScreenState extends State<DiaryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DiaryServices diaryServices = DiaryServices();

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerMood = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  DateTime? _selectedDate;

  late Diary _diary;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(200),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _controllerDate.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      });
    }
  }

  Future<void> _saveDiaryPost() async {
    if (_formKey.currentState!.validate()) {
      try {
        Provider.of<DiaryProvider>(context, listen: false).createEntryDiary(
          _controllerTitle.text.trim(),
          _controllerDescription.text.trim(),
          _controllerMood.text.trim(),
          _selectedDate!.toUtc().toIso8601String(),
          widget.user.id,
        );

        // diaryServices.newPostActivity(
        //   _controllerTitle.text.trim(),
        //   _controllerDescription.text.trim(),
        //   _controllerMood.text.trim(),
        //   _selectedDate!.toUtc().toIso8601String(),
        //   widget.user.id,
        // );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Actividad registrada correctamente',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromRGBO(53, 49, 149, 1),
          ),
        );
        setState(() {
          _controllerTitle.clear();
          _controllerDescription.clear();
          _controllerMood.clear();
          _controllerDate.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al registrar la actividad',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromRGBO(53, 49, 149, 1),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 248, 246, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.blueGrey,
        title: Text(
          'Nueva Entrada',
          style: GoogleFonts.lato(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Color.fromRGBO(210, 224, 238, 1).withOpacity(0.97),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nueva Entrada',
                    style: GoogleFonts.lato(
                      color: Colors.blueGrey[800],
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _controllerTitle,
                    style: GoogleFonts.lato(
                      color: Colors.blueGrey[900],
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Título',
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey[400]),
                      prefixIcon: Icon(
                        Icons.title,
                        color: Colors.blueGrey[300],
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'No se pueden enviar campos vacíos'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllerDescription,
                    maxLines: 4,
                    style: GoogleFonts.lato(color: Colors.blueGrey[900]),
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey[400]),
                      prefixIcon: Icon(
                        Icons.description,
                        color: Colors.blueGrey[300],
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'No se pueden enviar campos vacíos'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllerMood,
                    style: GoogleFonts.lato(color: Colors.blueGrey[900]),
                    decoration: InputDecoration(
                      labelText: 'Estado de ánimo',
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey[400]),
                      prefixIcon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueGrey[300],
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'No se pueden enviar campos vacíos'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllerDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la fecha';
                      }
                      return null;
                    },
                    readOnly: true,
                    style: GoogleFonts.lato(color: Colors.blueGrey[900]),
                    decoration: InputDecoration(
                      labelText: "Fecha",
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey[400]),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blueGrey[300],
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(
                        Icons.edit_calendar,
                        color: Colors.blueGrey[300],
                      ),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blueGrey,
                            side: BorderSide(color: Colors.blueGrey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                          label: Text(
                            'Cancelar',
                            style: GoogleFonts.lato(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _saveDiaryPost,
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text(
                            'Guardar',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
