import 'package:flutter/material.dart';

import 'package:app_my_diary/screens/HomeScreens/HomePage.dart';
import 'package:app_my_diary/screens/AuthScreens/LoginScreen.dart';
import 'package:app_my_diary/screens/AuthScreens/RegisterScreen.dart';
import 'package:app_my_diary/screens/SplashScreen.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(), 
        '/register': (context) => RegisterScreen(),
        '/homepage': (context) => HomePageScreen(),
      },
    );
  }
}
