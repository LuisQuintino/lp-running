import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      default:
        route = '/home';
    }
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.pageTitle != null
          ? AppBar(
              backgroundColor: Colors.grey[800],
              iconTheme: const IconThemeData(color: Colors.white),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
              toolbarHeight: 56,
              leading: widget.showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        }
                      },
                    )
                  : null,
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
          Container(width: 10, color: Colors.grey[800]),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: widget.child,
            ),
          ),
          Container(width: 10, color: Colors.grey[800]),
        ],
      ),
      bottomNavigationBar: widget.showBottomNavigationBar
          ? BottomNavigationBar(
              currentIndex: widget.currentIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.black54,
              backgroundColor: Colors.grey[400],
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timer),
                  label: 'Cronômetro',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Atletas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            )
          : null,
    );
  }
}
