import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import 'register_training_type_screen.dart';

class TrainingTypesScreen extends StatefulWidget {
  final int currentIndex;

  const TrainingTypesScreen({super.key, this.currentIndex = 2});

  @override
  _TrainingTypesScreenState createState() => _TrainingTypesScreenState();
}

class _TrainingTypesScreenState extends State<TrainingTypesScreen> {
  final List<Map<String, dynamic>> _activities = [
    {
      'name': 'Treino Fácil',
      'level': 'Básico',
      'duration': '30 minutos',
      'enabled': true,
      'archived': false,
    },
    {
      'name': 'Treino Intermediário',
      'level': 'Médio',
      'duration': '45 minutos',
      'enabled': false,
      'archived': false,
    },
    {
      'name': 'Treino Avançado',
      'level': 'Avançado',
      'duration': '60 minutos',
      'enabled': true,
      'archived': false,
    },
  ];

  final List<Map<String, dynamic>> _archivedActivities = [];

  void _addNewActivity(String name, String level, String duration) {
    setState(() {
      _activities.add({
        'name': name,
        'level': level,
        'duration': duration,
        'enabled': true,
        'archived': false,
      });
    });
  }

  void _archiveActivity(int index) {
    setState(() {
      _activities[index]['enabled'] = false;
      _archivedActivities.add(_activities[index]);
      _activities.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Treino arquivado com sucesso!'),
      ),
    );
  }

  void _unarchiveActivity(int index) {
    setState(() {
      Map<String, dynamic> unarchivedActivity = _archivedActivities[index];
      unarchivedActivity['enabled'] = false;
      unarchivedActivity['archived'] = false;
      _activities.add(unarchivedActivity);
      _archivedActivities.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Treino desarquivado com sucesso!'),
      ),
    );
    Navigator.of(context).pop();
  }

  void _navigateToRegisterActivity(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterTrainingTypeScreen(
          onRegisterTraining: (String name, String level, String duration) {
            _addNewActivity(name, level, duration);
          },
        ),
      ),
    );
  }

  void _viewArchivedActivities(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _archivedActivities.length,
          itemBuilder: (context, index) {
            final activity = _archivedActivities[index];
            return ListTile(
              title: Text(activity['name']),
              subtitle: Text('${activity['level']} - ${activity['duration']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: activity['enabled'],
                    onChanged: (bool value) {
                      setState(() {
                        _archivedActivities[index]['enabled'] = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                  IconButton(
                    icon: const Icon(Icons.unarchive, color: Colors.blue),
                    onPressed: () {
                      _unarchiveActivity(index);
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
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: widget.currentIndex,
      pageTitle: 'Training Types',
      actions: [
        IconButton(
          icon: const Icon(Icons.archive),
          onPressed: () {
            _viewArchivedActivities(context);
          },
        ),
      ],
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _activities.length,
                    itemBuilder: (context, index) {
                      final activity = _activities[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: activity['enabled']
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                        child: ListTile(
                          title: Text(activity['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(activity['level']),
                              Text(activity['duration']),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: activity['enabled'],
                                onChanged: (bool value) {
                                  setState(() {
                                    _activities[index]['enabled'] = value;
                                  });
                                },
                                activeColor: Colors.green,
                                inactiveThumbColor: Colors.red,
                              ),
                              IconButton(
                                icon: const Icon(Icons.archive, color: Colors.blue),
                                onPressed: () {
                                  _archiveActivity(index);
                                },
                              ),
                            ],
                          ),
                          leading: Icon(
                            Icons.edit,
                            color: Theme.of(context).iconTheme.color,
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
                _navigateToRegisterActivity(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
