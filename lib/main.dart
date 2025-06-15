import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:app_my_diary/providers/DiaryProvider.dart';
import 'package:app_my_diary/providers/NoteProvider.dart';
import 'package:app_my_diary/providers/PhotoProvider.dart';
import 'package:app_my_diary/providers/UserProvider.dart';
import 'package:app_my_diary/providers/weather_provider.dart';
import 'package:app_my_diary/screens/HomeScreens/HomePage.dart';
import 'package:app_my_diary/screens/AuthScreens/LoginScreen.dart';
import 'package:app_my_diary/screens/AuthScreens/RegisterScreen.dart';
import 'package:app_my_diary/screens/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DiaryProvider()),
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Diary V2',
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
