import 'package:flutter/material.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/services/UserServices.dart';
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: Color.fromRGBO(251, 248, 246, 1),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueGrey[900]),
        title: Text(
          'Editar Perfil',
          style: GoogleFonts.lato(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(251, 248, 246, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.blueGrey[100],
                    child: Icon(
                      Icons.person,
                      size: 54,
                      color: Colors.blueGrey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: controllerName,
                    label: 'Nombre',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: controllerLastName,
                    label: 'Apellido',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: controllerUsername,
                    label: 'Nombre de usuario',
                    icon: Icons.alternate_email,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: controllerEmail,
                    label: 'Correo',
                    icon: Icons.email_outlined,
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
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
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
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Regresar',
                            style: GoogleFonts.lato(
                              color: Colors.blueGrey[900],
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: saveChange,
                          child: Text(
                            'Guardar',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 17,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, este campo no puede ir vacío';
            }
            return null;
          },
      style: GoogleFonts.lato(color: Colors.blueGrey[900]),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.lato(color: Colors.blueGrey[700], fontSize: 16),
        prefixIcon: Icon(icon, color: Colors.blueGrey),
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
