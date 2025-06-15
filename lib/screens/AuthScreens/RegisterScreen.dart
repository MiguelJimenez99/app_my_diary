import 'package:flutter/material.dart';
import 'package:app_my_diary/services/AuthUser.dart';
import 'package:google_fonts/google_fonts.dart';

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

        setState(() {
          _controllerName.clear();
          _controllerLastname.clear();
          _controllerUserName.clear();
          _controllerEmail.clear();
          _controllerPassword.clear();
          _controllerConfirmPass.clear();
        });

        _alertMessage(result);
      } catch (e) {
        _alertMessage('Error al registrar usuario: $e');
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
                    'REGISTRO',
                    style: GoogleFonts.lato(
                      color: Colors.blueGrey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey),
                      prefixIcon: Icon(
                        Icons.person_2_outlined,
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
                    keyboardType: TextInputType.text,
                    controller: _controllerName,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey),
                      prefixIcon: Icon(
                        Icons.person_3_outlined,
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
                    keyboardType: TextInputType.text,
                    controller: _controllerLastname,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey),
                      prefixIcon: Icon(
                        Icons.person_4_outlined,
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
                    keyboardType: TextInputType.text,
                    controller: _controllerUserName,
                  ),
                  const SizedBox(height: 18),
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
                    style: GoogleFonts.lato(color: Colors.blueGrey[900]),
                    keyboardType: TextInputType.emailAddress,
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
                    controller: _controllerPassword,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      labelStyle: GoogleFonts.lato(color: Colors.blueGrey),
                      prefixIcon: Icon(
                        Icons.lock_outline_sharp,
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
                    controller: _controllerConfirmPass,
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
                      onPressed: _registerUser,
                      child: Text(
                        'Registrarse',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.blueGrey),
                  const SizedBox(height: 8),
                  Text(
                    '¿Ya tienes una cuenta?',
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
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Iniciar sesión',
                        style: GoogleFonts.lato(
                          color: Colors.blueGrey[900],
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
