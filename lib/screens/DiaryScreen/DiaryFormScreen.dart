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
        backgroundColor: Color.fromRGBO(251, 248, 246, 1),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueGrey[900]),
        title: Text(
          'Nueva Entrada',
          style: GoogleFonts.lato(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.bold,
            fontSize: 24,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.08),
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
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _modernTextField(
                    controller: _controllerTitle,
                    label: 'Título',
                    icon: Icons.title,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'No se pueden enviar campos vacíos'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  _modernTextField(
                    controller: _controllerDescription,
                    label: 'Descripción',
                    icon: Icons.description,
                    maxLines: 4,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'No se pueden enviar campos vacíos'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  _modernTextField(
                    controller: _controllerMood,
                    label: 'Estado de ánimo',
                    icon: Icons.emoji_emotions,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'No se pueden enviar campos vacíos'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  _modernTextField(
                    controller: _controllerDate,
                    label: 'Fecha',
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la fecha';
                      }
                      return null;
                    },
                    suffixIcon: Icons.edit_calendar,
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
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.blueGrey[900],
                            ),
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
                              fontWeight: FontWeight.bold,
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

  Widget _modernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool readOnly = false,
    void Function()? onTap,
    String? Function(String?)? validator,
    IconData? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: GoogleFonts.lato(color: Colors.blueGrey[900]),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.lato(color: Colors.blueGrey[700], fontSize: 16),
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        suffixIcon:
            suffixIcon != null
                ? Icon(suffixIcon, color: Colors.blueGrey[300])
                : null,
        filled: true,
        fillColor: Colors.blueGrey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}
