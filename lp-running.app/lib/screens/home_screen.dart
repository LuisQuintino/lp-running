import 'package:flutter/material.dart';

import '../widgets/base_screen.dart';
import 'athletes_screen.dart';
import 'cronometro_screen.dart';
import 'perfil_screen.dart';
import 'training_types_screen.dart';

class HomeScreen extends StatefulWidget {
  final String activeCoach;
  final String role;

  const HomeScreen({
    super.key,
    required this.activeCoach,
    required this.role,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int? index = ModalRoute.of(context)?.settings.arguments as int?;
    if (index != null) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bom dia';
    } else if (hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  List<Widget> get _screens {
    return [
      _buildHomeContent(),
      const CronometroScreen(),
      const AthletesScreen(currentIndex: 2),
      const PerfilScreen(),
    ];
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingBar(),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => _navigateToIndex(1),
            child: _buildImageCard('Cronômetro', 'lib/assets/images/stopwatch.png'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _navigateToIndex(2),
            child: _buildImageCard('Atletas', 'lib/assets/images/athletes.png'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _navigateToTrainingTypes,
            child: _buildImageCard('Tipos de Treino', 'lib/assets/images/training_types.png'),
          ),
          const SizedBox(height: 16),
          if (widget.role == 'Master')
            GestureDetector(
              onTap: _navigateToCoaches,
              child: _buildImageCard('Coaches', 'lib/assets/images/coaches.png'),
            ),
        ],
      ),
    );
  }

  Widget _buildGreetingBar() {
    return Container(
      width: double.infinity,
      color: Colors.grey[800],
      padding: const EdgeInsets.all(16.0),
      child: Text(
        '${_getGreeting()}, Coach ${widget.activeCoach}!',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildImageCard(String label, String imagePath) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          width: double.infinity,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToTrainingTypes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrainingTypesScreen(),
      ),
    );
  }

  void _navigateToCoaches() {
    Navigator.of(context).pushNamed('/coaches');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: _currentIndex,
      pageTitle: null,
      showBackButton: false,
      child: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    );
  }
}
