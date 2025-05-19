import 'package:flutter/material.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/services/UserServices.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});
  final User user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  UserService userService = UserService();

  late TextEditingController controllerName;
  late TextEditingController controllerLastName;
  late TextEditingController controllerUsername;
  late TextEditingController controllerEmail;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerName = TextEditingController(text: widget.user.name);
    controllerLastName = TextEditingController(text: widget.user.lastname);
    controllerUsername = TextEditingController(text: widget.user.username);
    controllerEmail = TextEditingController(text: widget.user.email);
  }

  void saveChange() async {
    try {
      if (_formKey.currentState!.validate()) {
        await userService.updateDataUser(
          widget.user.id,
          controllerName.text.trim(),
          controllerLastName.text.trim(),
          controllerUsername.text.trim(),
          controllerEmail.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Datos actualizados correctamente',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromRGBO(53, 49, 149, 1),
          ),
        );
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al actualizar: $e',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromRGBO(53, 49, 149, 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerLastName.dispose();
    controllerUsername.dispose();
    controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0F172A),
      ),
      backgroundColor: Color(0xFF0F172A),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFF0F172A)),
          child: FutureBuilder<User>(
            future: userService.getDataUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              'Editar Perfil',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.person, size: 50),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(color: Colors.white),
                            autofocus: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, este campo no puede ir vacio';
                              }
                              return null;
                            },

                            controller: controllerName,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Apellido',
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(color: Colors.white),
                            autofocus: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, este campo no puede ir vacio';
                              }
                              return null;
                            },

                            controller: controllerLastName,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nombre de usuario',
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(color: Colors.white),
                            autofocus: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, este campo no puede ir vacio';
                              }
                              return null;
                            },

                            controller: controllerUsername,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Correo',
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(color: Colors.white),
                            autofocus: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El correo es obligatorio';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );

                              if (!emailRegex.hasMatch(value)) {
                                return 'Correo no válido';
                              }
                              return null;
                            },

                            controller: controllerEmail,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Regresar',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                              ),
                              onPressed: saveChange,
                              child: Text(
                                'Guardar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'No hay datos',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
