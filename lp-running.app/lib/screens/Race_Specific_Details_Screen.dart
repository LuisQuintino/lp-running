import 'package:flutter/material.dart';

class RaceSpecificDetailsScreen extends StatefulWidget {
  final String raceId;

  const RaceSpecificDetailsScreen({
    super.key,
    required this.raceId,
  });

  @override
  _RaceSpecificDetailsScreenState createState() =>
      _RaceSpecificDetailsScreenState();
}

class _RaceSpecificDetailsScreenState extends State<RaceSpecificDetailsScreen> {
  bool _isEditingDescription = false;
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _descriptionHistory = [];
  late Future<Map<String, dynamic>> raceDetailsFuture;

  @override
  void initState() {
    super.initState();
    raceDetailsFuture = fetchRaceDetails(widget.raceId);
  }

  Future<Map<String, dynamic>> fetchRaceDetails(String raceId) async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'time': '11.2 seconds',
      'averageSpeed': '8.93 m/s',
      'description': 'Race description from the database',
    };
  }

  Future<void> _saveDescriptionToDatabase(String newDescription) async {
    await Future.delayed(const Duration(seconds: 1));
    print('Description saved to the database: $newDescription');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Race Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: raceDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading race details.'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No race details found.'));
          }

          final raceDetails = snapshot.data!;
          final time = raceDetails['time'] ?? 'Unknown';
          final averageSpeed = raceDetails['averageSpeed'] ?? 'Unknown';
          final description = raceDetails['description'] ?? 'No description available';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'General',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('• Time: $time'),
                      Text('• Average speed: $averageSpeed'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (_isEditingDescription)
                        TextField(
                          controller: _descriptionController..text = description,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Edit description here...',
                          ),
                        )
                      else
                        Text(
                          description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(
                            _isEditingDescription ? Icons.check : Icons.edit,
                            size: 20,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () async {
                            if (_isEditingDescription && _descriptionController.text.isNotEmpty) {
                              await _saveDescriptionToDatabase(_descriptionController.text);
                              _descriptionHistory.add(_descriptionController.text);
                            }

                            setState(() {
                              _isEditingDescription = !_isEditingDescription;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
