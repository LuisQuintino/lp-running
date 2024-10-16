import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import 'register_coach_screen.dart';

class CoachListScreen extends StatefulWidget {
  const CoachListScreen({super.key});

  @override
  _CoachListScreenState createState() => _CoachListScreenState();
}

class _CoachListScreenState extends State<CoachListScreen> {
  late Future<List<Map<String, dynamic>>> coachesFuture;

  @override
  void initState() {
    super.initState();
    coachesFuture = fetchCoachesFromDatabase();
  }

  Future<List<Map<String, dynamic>>> fetchCoachesFromDatabase() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      {
        'name': 'Coach 001',
        'email': 'coach001@example.com',
        'role': 'Admin',
        'active': true
      },
      {
        'name': 'Coach 002',
        'email': 'coach002@example.com',
        'role': 'Coach',
        'active': false
      },
      {
        'name': 'Master Ramires',
        'email': 'mastercoach@example.com',
        'role': 'Master',
        'active': true
      },
    ];
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
              coachesFuture = fetchCoachesFromDatabase();
            });
          },
          isEditing: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 2,
      pageTitle: 'Coaches',
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
                        color: Theme.of(context).primaryColor,
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
                            children: [
                              Text(
                                coach['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editCoach(index, coaches),
                              ),
                            ],
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
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Permissão: ${coach['role'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Switch(
                                value: coach['active'] ?? false,
                                onChanged: (bool value) {
                                  setState(() {
                                    coach['active'] = value;
                                  });
                                },
                                activeColor: Colors.green,
                                inactiveThumbColor: Colors.red,
                                inactiveTrackColor: Colors.red.withOpacity(0.3),
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
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
