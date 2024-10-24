import 'package:flutter/material.dart';
import 'register_athlete_screen.dart';
import 'race_details_screen.dart';
import '../widgets/base_screen.dart';

class AthletesScreen extends StatefulWidget {
  const AthletesScreen({super.key});

  @override
  _AthletesScreenState createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen> {
  String? selectedAthlete;
  List<Map<String, dynamic>> athletes = [];
  List<Map<String, dynamic>> filteredAthletes = [];
  final List<Map<String, dynamic>> _archivedAthletes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    athletes = [
      {'name': 'Dona Maria', 'active': true, 'archived': false},
      {'name': 'João Silva', 'active': false, 'archived': false},
      {'name': 'Maria Clara', 'active': true, 'archived': false},
    ];
    filteredAthletes = List.from(athletes);
    searchController.addListener(_filterAthletes);
  }

  void _filterAthletes() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredAthletes = athletes.where((athlete) {
        final athleteName = athlete['name']!.toLowerCase();
        return athleteName.contains(query);
      }).toList();
    });
  }

  void _addNewAthlete(String name, String imageUrl) {
    setState(() {
      athletes.add({'name': name, 'active': true, 'archived': false});
      _filterAthletes();
    });
  }

  void _archiveAthlete(int index) {
    setState(() {
      filteredAthletes[index]['archived'] = true;
      _archivedAthletes.add(filteredAthletes[index]);
      athletes.removeAt(athletes.indexOf(filteredAthletes[index]));
      _filterAthletes();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Athlete archived successfully!')),
    );
  }

  void _unarchiveAthlete(int index) {
    setState(() {
      final athlete = _archivedAthletes[index];
      athlete['archived'] = false;
      athletes.add(athlete);
      _archivedAthletes.removeAt(index);
      _filterAthletes();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Athlete unarchived successfully!')),
    );
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
    return BaseScreen(
      currentIndex: 2,
      pageTitle: 'Athletes',
      actions: [
        IconButton(
          icon: const Icon(Icons.archive),
          onPressed: () {
            _viewArchivedAthletes(context);
          },
        ),
      ],
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search',
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
                  child: ListView.builder(
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
                                ? Colors.grey
                                : Colors.white,
                            border: Border.all(color: Colors.black), // Borda preta
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => RegisterAthleteScreen(
                                            onRegisterAthlete: _addNewAthlete,
                                            athleteName: athlete['name'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.edit, color: Colors.black), // Ícone editado para verde
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    athlete['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
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
                                    inactiveThumbColor: Colors.grey.shade400,
                                    activeTrackColor: Colors.lightGreen.shade200,
                                    inactiveTrackColor: Colors.grey.shade300,
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
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
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
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
