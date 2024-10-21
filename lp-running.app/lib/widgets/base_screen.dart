import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final String? pageTitle;
  final bool showBackButton;
  final bool showBottomNavigationBar;
  final List<Widget>? actions;

  const BaseScreen({
    super.key,
    required this.child,
    required this.currentIndex,
    this.pageTitle,
    this.showBackButton = true,
    this.showBottomNavigationBar = true,
    this.actions,
  });

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    String route;
    switch (index) {
      case 0:
        route = '/home';
        break;
      case 1:
        route = '/cronometro';
        break;
      case 2:
        route = '/atletas';
        break;
      case 3:
        route = '/perfil';
        break;
      case 4:
        route = '/coaches';
        break;
      case 5:
        route = '/training-types';
        break;
      case 6:  // Novo caso para Configurações
        route = '/master-control';  // Direcionando para MasterControlScreen
        break;
      default:
        route = '/home';
    }
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.pageTitle != null
          ? AppBar(
              backgroundColor: Colors.grey[800],
              iconTheme: const IconThemeData(color: Colors.white),
              toolbarHeight: 56,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              title: Text(
                widget.pageTitle ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              actions: widget.actions,
              elevation: 0,
            )
          : null,
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: widget.child,
            ),
          ),
        ],
      ),
      drawer: _buildDrawerMenu(),
    );
  }

  Widget _buildDrawerMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildMenuOption(Icons.home, 'Home', 0),
          _buildMenuOption(Icons.timer, 'Cronômetro', 1),
          _buildMenuOption(Icons.people, 'Atletas', 2),
          _buildMenuOption(Icons.person, 'Perfil', 3),
          _buildMenuOption(Icons.construction, 'Coaches', 4),
          _buildMenuOption(Icons.directions_run, 'Tipos de Treino', 5),
          _buildMenuOption(Icons.settings, 'Controle de Acesso', 6), 
        ],
      ),
    );
  }

  ListTile _buildMenuOption(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        _onItemTapped(index);
      },
    );
  }
}
