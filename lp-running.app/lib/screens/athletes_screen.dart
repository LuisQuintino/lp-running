import 'package:flutter/material.dart'; 
import 'register_athlete_screen.dart';
import 'race_details_screen.dart';

class AthletesScreen extends StatefulWidget {
  final int currentIndex;

  const AthletesScreen({super.key, required this.currentIndex});

  @override
  _AthletesScreenState createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen> {
  String? selectedAthlete;
  List<Map<String, dynamic>> filteredAthletes = [];
  final List<Map<String, dynamic>> _archivedAthletes = [];
  TextEditingController searchController = TextEditingController();
  bool showSearchField = false;
  late Future<List<Map<String, dynamic>>> athletesFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    athletesFuture = fetchAthletes();
    searchController.addListener(_filterAthletes);
  }

  Future<List<Map<String, dynamic>>> fetchAthletes() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      {'name': 'Dona Maria', 'active': true, 'archived': false},
      {'name': 'João Silva', 'active': false, 'archived': false},
      {'name': 'Maria Clara', 'active': true, 'archived': false},
    ];
  }

  void _filterAthletes() {
    athletesFuture.then((athletes) {
      setState(() {
        filteredAthletes = athletes
            .where((athlete) =>
                athlete['name'].toLowerCase().contains(searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  void _addNewAthlete(String name, String imageUrl) {
    setState(() {
      filteredAthletes.add({'name': name, 'active': true, 'archived': false});
    });
  }

  void _archiveAthlete(int index) {
    setState(() {
      filteredAthletes[index]['active'] = false; 
      _archivedAthletes.add(filteredAthletes[index]); 
      filteredAthletes.removeAt(index); 
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Atleta arquivado e desativado com sucesso!')),
    );
  }

  void _unarchiveAthlete(int index) {
    setState(() {
      final athlete = _archivedAthletes[index];
      athlete['active'] = false; 
      filteredAthletes.add(athlete); 
      _archivedAthletes.removeAt(index); 
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Atleta desarquivado com sucesso!')),
    );

    Navigator.of(context).pop(); 
  }

  void _viewArchivedAthletes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _archivedAthletes.length,
          itemBuilder: (context, index) {
            final athlete = _archivedAthletes[index];
            return ListTile(
              title: Text(athlete['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: athlete['active'],
                    onChanged: (bool value) {
                      setState(() {
                        _archivedAthletes[index]['active'] = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                  IconButton(
                    icon: const Icon(Icons.unarchive, color: Colors.blue),
                    onPressed: () {
                      _unarchiveAthlete(index);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Atletas',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.grey[800],
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () {
              _viewArchivedAthletes(context); 
            },
          ),
        ],
      ),
      drawer: Drawer(
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
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Cronômetro'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/cronometro');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Atletas'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/atletas');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/perfil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.business_center),
              title: const Text('Coaches'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/coaches');
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Tipos de Treino'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/training-types');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (showSearchField)
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  hintText: 'Buscar atleta',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>( 
                future: athletesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao buscar atletas.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum atleta encontrado.'));
                  }

                  filteredAthletes = snapshot.data!;
                  return ListView.builder(
                    itemCount: filteredAthletes.length,
                    itemBuilder: (context, index) {
                      final athlete = filteredAthletes[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAthlete = athlete['name'];
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RaceDetailsScreen(
                                athleteName: athlete['name'],
                                imageUrl: 'https://example.com/athlete_image.png',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedAthlete == athlete['name']
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                            border: Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                athlete['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: selectedAthlete == athlete['name']
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Switch(
                                    value: athlete['active'],
                                    onChanged: (bool value) {
                                      setState(() {
                                        filteredAthletes[index]['active'] = value;
                                      });
                                    },
                                    activeColor: Colors.green,
                                    inactiveThumbColor: Colors.red,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.archive, color: Colors.blue),
                                    onPressed: () {
                                      _archiveAthlete(index);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RegisterAthleteScreen(
                onRegisterAthlete: _addNewAthlete,
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
