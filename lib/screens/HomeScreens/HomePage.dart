import 'package:flutter/material.dart';
import 'package:app_my_diary/screens/DashBoard.dart';
import 'package:app_my_diary/screens/DiaryScreen/DiaryScreen.dart';
import 'package:app_my_diary/screens/GalleryScreens/GalleryScreen.dart';
import 'package:app_my_diary/screens/ProfileScreens/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashBoardScreen(),
    DiaryScreen(),
    GalleryScreen(),
    ProfileScreen(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: AppBar(
          backgroundColor: Color.fromRGBO(251, 248, 246, 1),

          actions: [
            IconButton(
              onPressed: logOut,
              icon: Icon(Icons.exit_to_app, color: Colors.black),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(210, 224, 238, 1),
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black26,
        elevation: 6,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Diary'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Gallery'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
