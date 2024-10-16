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
  final List<Map<String, dynamic>> _activities = [];

  void _addNewActivity(String name, String level, String duration) {
    setState(() {
      _activities.add({
        'name': name,
        'level': level,
        'duration': duration,
        'enabled': true,
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: widget.currentIndex,
      pageTitle: 'Training Types',
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
                          trailing: Switch(
                            value: activity['enabled'],
                            onChanged: (bool value) {
                              setState(() {
                                _activities[index]['enabled'] = value;
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                            inactiveThumbColor: Colors.grey,
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
