import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  String _coachName = "Ache um Bug 😉"; 

  void _navigateToScreen(String routeName) {
    Navigator.pushNamed(context, routeName);
  }


  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => _navigateToScreen('/cronometro'),
            child: _buildImageCard('Cronômetro', 'lib/assets/images/stopwatch.png'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _navigateToScreen('/atletas'),
            child: _buildImageCard('Atletas', 'lib/assets/images/athletes.png'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _navigateToScreen('/training-types'),
            child: _buildImageCard('Tipos de Treino', 'lib/assets/images/training_types.png'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _navigateToScreen('/coaches'),
            child: _buildImageCard('Coaches', 'lib/assets/images/coaches.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String label, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 0, 
      pageTitle: '${_getGreeting()}, $_coachName',
      child: _buildHomeContent(), 
    );
  }
}
