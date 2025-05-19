import 'package:flutter/material.dart';
import 'package:app_my_diary/services/AuthUser.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final AuthServices authServices = AuthServices();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

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

  Future<void> actionsLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final result = await authServices.loginService(
          _controllerEmail.text.trim(),
          _controllerPassword.text.trim(),
        );

        setState(() {
          isLoading = false;
        });

        if (result == 'success') {
          Navigator.pushReplacementNamed(context, '/homepage');
        } else {
          _alertMessage(result);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _alertMessage('Error al iniciar sesion');
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
          child: Center(
            child: SizedBox(
              width: 350,
              height: 600,
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
                        'LOGIN',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.email_outlined),
                                prefixIconColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor , Ingrese la contraseña';
                                }
                                return null;
                              },
                              controller: _controllerPassword,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GestureDetector(
                                  child: Text(
                                    'Forgot password?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    print('Olvidaste la contraseña');
                                  },
                                ),
                              ),
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
                          onPressed: actionsLogin,
                          child: Text(
                            'Log In',
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                        'Don´t have an account?',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/register',
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   child: Text(
                      //     'Sign up',
                      //     style: TextStyle(
                      //       color: Color.fromRGBO(53, 49, 149, 1),
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
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5), // fondo semitransparente
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
