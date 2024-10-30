import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import 'register_coach_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoachListScreen extends StatefulWidget {
  const CoachListScreen({super.key});

  @override
  _CoachListScreenState createState() => _CoachListScreenState();
}

class _CoachListScreenState extends State<CoachListScreen> {
  late Future<List<Map<String, dynamic>>> coachesFuture;
  final List<Map<String, dynamic>> _archivedCoaches = [];

  @override
  void initState() {
    super.initState();
    coachesFuture = fetchCoachesFromApi();
  }

  // Função para buscar os coaches diretamente da API
  Future<List<Map<String, dynamic>>> fetchCoachesFromApi() async {
    final url = Uri.parse('http://localhost:3000/api/coaches');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((coach) {
        return {
          'name': coach['name'],
          'email': coach['email'],
          'role': coach['role'],
          'active': coach['active'],
          'archived': false,
        };
      }).toList();
    } else {
      throw Exception('Erro ao carregar coaches: ${response.statusCode}');
    }
  }

  void _editCoach(int index, List<Map<String, dynamic>> coaches) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterCoachScreen(
          coach: coaches[index],
          onRegister: (updatedCoach) {
            setState(() {
              coaches[index] = updatedCoach;
            });
          },
          isEditing: true,
        ),
      ),
    );
  }

  void _addNewCoach() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterCoachScreen(
          onRegister: (newCoach) {
            setState(() {
              coachesFuture = fetchCoachesFromApi();
            });
          },
          isEditing: false,
        ),
      ),
    );
  }

  void _archiveCoach(int index, List<Map<String, dynamic>> coaches) {
    setState(() {
      coaches[index]['active'] = false;
      _archivedCoaches.add(coaches[index]);
      coaches.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coach arquivado e desativado com sucesso!')),
    );
  }

  void _unarchiveCoach(int index) {
    setState(() {
      final coach = _archivedCoaches[index];
      coach['active'] = true;
      coachesFuture = coachesFuture.then((coaches) => [...coaches, coach]);
      _archivedCoaches.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coach desarquivado com sucesso!')),
    );
    Navigator.of(context).pop();
  }

  void _viewArchivedCoaches(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _archivedCoaches.length,
          itemBuilder: (context, index) {
            final coach = _archivedCoaches[index];
            return ListTile(
              title: Text(coach['name']),
              subtitle: Text('${coach['role']} - ${coach['email']}'),
              trailing: IconButton(
                icon: const Icon(Icons.unarchive, color: Colors.blue),
                onPressed: () {
                  _unarchiveCoach(index);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 2,
      pageTitle: 'Coaches',
      actions: [
        IconButton(
          icon: const Icon(Icons.archive),
          onPressed: () {
            _viewArchivedCoaches(context);
          },
        ),
      ],
      child: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: coachesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar os coaches.'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhum coach cadastrado.'));
              }

              final coaches = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: coaches.length,
                itemBuilder: (context, index) {
                  final coach = coaches[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coach['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Email: ${coach['email'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tipo de Conta: ${coach['role'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.black),
                                    onPressed: () => _editCoach(index, coaches),
                                  ),
                                  Switch(
                                    value: coach['active'] ?? false,
                                    onChanged: (bool value) {
                                      setState(() {
                                        coach['active'] = value;
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
                                      _archiveCoach(index, coaches);
                                    },
                                  ),
                                ],
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
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _addNewCoach,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
