import 'package:flutter/material.dart';

class CronometroScreen extends StatelessWidget {
  const CronometroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cronômetro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Cronômetro',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
