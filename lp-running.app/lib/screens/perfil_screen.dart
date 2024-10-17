import 'package:flutter/material.dart';

import '../widgets/base_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      currentIndex: 3,
      pageTitle: 'Perfil',
      child: Center(
        child: Text(
          'Detalhes do Perfil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
