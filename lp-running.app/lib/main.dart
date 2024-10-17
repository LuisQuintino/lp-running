import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/cronometro_screen.dart';
import 'screens/athletes_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/coach_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lp_Running',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          elevation: 0,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.green,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(activeCoach: 'Master', role: 'Master'),
        '/cronometro': (context) => const CronometroScreen(),
        '/atletas': (context) => const AthletesScreen(currentIndex: 2),
        '/perfil': (context) => const PerfilScreen(),
        '/coaches': (context) => const CoachListScreen(),
      },
    );
  }
}
