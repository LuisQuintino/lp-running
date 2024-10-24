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
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String _coachName = "Find a Bug 😉"; //substituir pela pessoa logada

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Função para buscar o nome do usuário no bd
  }

  void _fetchUserName() async {
    // TODO: Adicione o código de conexão ao db aqui
  
  }

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
            onTap: () => _navigateToScreen('/stopwatch'),
            child: _buildImageCard('Stopwatch', 'lib/assets/images/stopwatch.png'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _navigateToScreen('/athletes'),
            child: _buildImageCard('Athletes', 'lib/assets/images/athletes.png'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _navigateToScreen('/training-types'),
            child: _buildImageCard('Training Types', 'lib/assets/images/training_types.png'),
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
