/*import 'package:dashbord_cine/app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TheApp(),
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}*/


// lib/main.dart
import 'package:dashbord_cine/views/dashboard_layout.dart';
import 'package:dashbord_cine/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinema Dashboard',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
        primaryColor: Color(0xFFE50914),
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFE50914),
          secondary: Color(0xFFFFD700),
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: SplashScreen()
      //DashboardLayout(),
    );
  }
}