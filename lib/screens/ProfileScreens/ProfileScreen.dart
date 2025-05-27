import 'package:flutter/material.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/screens/ProfileScreens/EditProfileScreen.dart';
import 'package:app_my_diary/services/UserServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final _dataUser = userService.getDataUser();
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
              final user = snapshot.data!;

              return Column(
                children: [
                  CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      user.name,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 100),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                      ),
                      onPressed: () async {
                        final userId = await userService.getDataUser();

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(user: userId),
                          ),
                        );

                        // Si se creó una nueva actividad, recarga la lista
                        if (result == true) {
                          setState(() {
                            _refresScreen(); // vuelve a ejecutar el Future
                          });
                        }

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (context) => EditProfileScreen(user: userId),
                        //   ),
                        // );
                      },
                      child: Text(
                        'Editar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        elevation: 10,
                        color: Color.fromRGBO(27, 34, 47, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              user.name,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        elevation: 10,
                        color: Color.fromRGBO(27, 34, 47, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Last Name',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              user.lastname,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        elevation: 10,
                        color: Color.fromRGBO(27, 34, 47, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Username',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              user.username,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: SizedBox(
                      height: 80,
                      child: Card(
                        elevation: 10,
                        color: Color.fromRGBO(27, 34, 47, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              user.email,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                      ),
                      onPressed: logOut,
                      child: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Text('No hay datos', style: TextStyle(color: Colors.red));
            }
          },
        ),
      ),
    );
  }
}
