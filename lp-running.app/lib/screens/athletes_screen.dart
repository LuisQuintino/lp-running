import 'package:flutter/material.dart';
import 'register_athlete_screen.dart';
import 'race_details_screen.dart';
import '../widgets/base_screen.dart';

class AthletesScreen extends StatefulWidget {
  final int currentIndex;

  const AthletesScreen({super.key, required this.currentIndex});

  @override
  _AthletesScreenState createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen> {
  String? selectedAthlete;
  List<String> filteredAthletes = [];
  TextEditingController searchController = TextEditingController();
  bool showSearchField = false;
  late Future<List<String>> athletesFuture;

  @override
  void initState() {
    super.initState();
    athletesFuture = fetchAthletes();
    searchController.addListener(_filterAthletes);
  }

  Future<List<String>> fetchAthletes() async {
    await Future.delayed(const Duration(seconds: 2));
    return ['Dona Maria', 'João Silva', 'Maria Clara'];
  }

  void _filterAthletes() {
    athletesFuture.then((athletes) {
      setState(() {
        filteredAthletes = athletes
            .where((athlete) => athlete.toLowerCase().contains(searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        return BaseScreen(
      currentIndex: widget.currentIndex,
      pageTitle: 'Atletas',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              showSearchField = !showSearchField;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // Implementar a lógica de filtros avançados
          },
        ),
      ],
      child: Container(
        color: Colors.grey[300],
        child: Padding(
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
                child: FutureBuilder<List<String>>(
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
                              selectedAthlete = athlete;
                            });
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RaceDetailsScreen(
                                  athleteName: athlete,
                                  imageUrl: 'https://example.com/athlete_image.png',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: selectedAthlete == athlete
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              border: Border.all(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  athlete,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: selectedAthlete == athlete
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RegisterAthleteScreen(
                                          onRegisterAthlete: (athleteName, athleteImageUrl) {
                                            setState(() {
                                              filteredAthletes[index] = athleteName;
                                            });
                                          },
                                          athleteName: athlete,
                                        ),
                                      ),
                                    );
                                  },
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
      ),
    );
  }
}
