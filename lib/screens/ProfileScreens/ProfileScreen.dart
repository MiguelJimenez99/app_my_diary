import 'package:flutter/material.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/screens/ProfileScreens/EditProfileScreen.dart';
import 'package:app_my_diary/services/UserServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _refresScreen();
  }

  void _refresScreen() {
    setState(() {
      // Solo refresca el estado, no es necesario asignar nada aquí
    });
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Color.fromRGBO(251, 248, 246, 1),
        child: FutureBuilder<User>(
          future: userService.getDataUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.blueGrey),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error}',
                  style: GoogleFonts.lato(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Color.fromRGBO(210, 224, 238, 1),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '${user.name} ${user.lastname}',
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: GoogleFonts.lato(
                        color: Colors.blueGrey[200],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 140,
                      height: 40,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                        ),
                        onPressed: () async {
                          final userId = await userService.getDataUser();
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(user: userId),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              _refresScreen();
                            });
                          }
                        },
                        icon: Icon(Icons.edit, color: Colors.white, size: 20),
                        label: Text(
                          'Editar',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _profileInfoCard('Nombre', user.name),
                    _profileInfoCard('Apellido', user.lastname),
                    _profileInfoCard('Usuario', user.username),
                    _profileInfoCard('Correo', user.email, isEmail: true),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                        ),
                        onPressed: logOut,
                        icon: Icon(Icons.logout, color: Colors.white, size: 22),
                        label: Text(
                          'Cerrar sesión',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            } else {
              return Text(
                'No hay datos',
                style: GoogleFonts.lato(color: Colors.red, fontSize: 18),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _profileInfoCard(String label, String value, {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Card(
        elevation: 8,
        color: Color.fromRGBO(251, 248, 246, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(
                  color: Colors.blueGrey[700],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: GoogleFonts.lato(
                    color: Colors.blueGrey[900],
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: isEmail ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
