import 'package:flutter/material.dart';
import 'package:app_my_diary/services/AuthUser.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 248, 246, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'My Diary V2',
                    style: GoogleFonts.lato(
                      color: Colors.blueGrey[900],
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'LOGIN',
                    style: GoogleFonts.lato(
                      color: Colors.blueGrey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.blueGrey,
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.lato(color: Colors.blueGrey[900]),
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
                  const SizedBox(height: 18),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.blueGrey,
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.lato(color: Colors.blueGrey[900]),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor , Ingrese la contraseña';
                      }
                      return null;
                    },
                    controller: _controllerPassword,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: actionsLogin,
                      child: Text(
                        'Iniciar sesión',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.blueGrey[200]),
                  const SizedBox(height: 8),
                  Text(
                    '¿No tienes una cuenta?',
                    style: GoogleFonts.lato(
                      color: Colors.blueGrey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blueGrey,
                        side: BorderSide(color: Colors.blueGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: Text(
                        'Registrarse',
                        style: GoogleFonts.lato(
                          color: Colors.blueGrey[900],
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CircularProgressIndicator(color: Colors.blueGrey),
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
