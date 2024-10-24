import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; 
import 'screens/home_screen.dart';
import 'screens/stopwatch_screen.dart';
import 'screens/athletes_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/coach_list_screen.dart';
import 'screens/training_types_screen.dart';
import 'screens/master_control_screen.dart';
import 'screens/login_screen.dart'; 


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LpRunning',
      initialRoute: '/splash', 
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/stopwatch': (context) => const StopwatchScreen(),
        '/athletes': (context) => const AthletesScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/coaches': (context) => const CoachListScreen(),
        '/training-types': (context) => const TrainingTypesScreen(),
        '/master-control': (context) => const MasterControlScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
