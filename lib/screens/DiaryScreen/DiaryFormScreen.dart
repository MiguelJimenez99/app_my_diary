import 'package:flutter/material.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/services/DiaryService.dart';

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
        await diaryServices.newPostActivity(
          _controllerTitle.text.trim(),
          _controllerDescription.text.trim(),
          _controllerMood.text.trim(),
          _selectedDate!.toUtc().toIso8601String(),
          widget.user.id,
        );

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

        await Future.delayed(Duration(seconds: 1));
        
        Navigator.pop(context, true);
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
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF0F172A),
      ),
      backgroundColor: Color(0xFF0F172A),
      body: SafeArea(
        child: Material(
          color: Color(0xFF0F172A),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Nueva Entrada',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            'Titulo',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 10,
                          bottom: 20,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          controller: _controllerTitle,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'No se pueden enviar campos vacios';
                            }
                            return null;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            'Descripción',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 10,
                        ),
                        child: TextFormField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Escribe tu historia...',
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          controller: _controllerDescription,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'No se pueden enviar campos vacios';
                            }
                            return null;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, top: 20),
                          child: Text(
                            'Estado de ánimo',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 10,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          controller: _controllerMood,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'No se pueden enviar campos vacios';
                            }
                            return null;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, top: 20),
                          child: Text(
                            'Fecha',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 10,
                        ),
                        child: TextFormField(
                          controller: _controllerDate,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Selecciona una fecha",
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0F172A),
                                  elevation: 10,
                                  side: BorderSide(color: Colors.grey),
                                ),
                                onPressed: () => {Navigator.pop(context)},
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(
                                    53,
                                    49,
                                    149,
                                    1,
                                  ),
                                  elevation: 10,
                                ),
                                onPressed: _saveDiaryPost,
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
