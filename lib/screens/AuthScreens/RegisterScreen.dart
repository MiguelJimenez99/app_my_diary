import 'package:flutter/material.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/services/AuthUser.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //variable que almacena la funcion para crear el nuevo usuario
  final AuthServices authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPass = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();

  void _alertMessage(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Alerta'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  bool _dataValidate() {
    final String name = _controllerName.text.trim();
    final String lastname = _controllerLastname.text.trim();
    final String username = _controllerUserName.text.trim();
    final String email = _controllerEmail.text.trim();
    final String password = _controllerPassword.text.trim();

    if (name.isEmpty ||
        lastname.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      _alertMessage('Todos los Campos son requeridos');
      return false;
    }
    return true;
  }

  bool _comparePassword() {
    final String password = _controllerPassword.text.trim();
    final String confirmPassword = _controllerConfirmPass.text.trim();

    if (password != confirmPassword) {
      _alertMessage('Las contraseñas no coinciden');
      return false;
    }
    return true;
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (!_dataValidate() || !_comparePassword()) return;

      try {
        final result = await authServices.registerService(
          _controllerName.text.trim(),
          _controllerLastname.text.trim(),
          _controllerUserName.text.trim(),
          _controllerEmail.text.trim(),
          _controllerPassword.text.trim(),
        );

        if (result.startsWith('Registro exitoso')) {
          _controllerName.clear();
          _controllerLastname.clear();
          _controllerUserName.clear();
          _controllerEmail.clear();
          _controllerPassword.clear();
          _controllerConfirmPass.clear();
        }

        _alertMessage(result);
      } catch (e) {
        _alertMessage('Error al registrar usuario: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color(0xFF0F172A), // azul oscuro
            //     Color(0xFF6D28D9), // morado
            //   ],
            // ),
            color: Color.fromRGBO(27, 34, 47, 1),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 350,
              height: 750,
              child: Material(
                // color: Color.fromRGBO(29, 36, 51, 1),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'My Diary V2',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      Text(
                        'REGISTER',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.person_2_outlined),
                                prefixIconColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              controller: _controllerName,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'LastName',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.person_3_outlined),
                                prefixIconColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              controller: _controllerLastname,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.person_4_outlined),
                                prefixIconColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              controller: _controllerUserName,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.email_outlined),
                                prefixIconColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El correo es obligatorio';
                                }

                                // Expresión regular para validar email
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );

                                if (!emailRegex.hasMatch(value)) {
                                  return 'Correo no válido';
                                }
                                return null; 
                              },
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              controller: _controllerEmail,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.lock_outline),
                                prefixIconColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(color: Colors.white),
                              obscureText: true,
                              controller: _controllerPassword,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.lock_outline_sharp),
                                prefixIconColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(color: Colors.white),
                              obscureText: true,
                              controller: _controllerConfirmPass,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                          ),
                          onPressed: _registerUser,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 15.0,
                          right: 15.0,
                          bottom: 20.0,
                        ),
                        child: Divider(color: Colors.white),
                      ),
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            'Log in',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   child: Text(
                      //     'Log in',
                      //     style: TextStyle(
                      //       color: Color.fromRGBO(58, 108, 213, 1),
                      //       fontSize: 30,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
