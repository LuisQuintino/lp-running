import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward(); 

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('/login'); // Vai para a tela de login
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/logo.png',
              height: 300,
            ),
            const SizedBox(height: 50),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 5,
                  color: Colors.black,
                  child: LinearProgressIndicator(
                    value: _animationController.value,
                    backgroundColor: Colors.black,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
