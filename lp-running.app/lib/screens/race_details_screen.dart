import 'package:flutter/material.dart';
import 'package:lp_runningflutter/screens/athlete_information_screen.dart';
import 'package:lp_runningflutter/screens/race_specific_details_screen.dart';

class RaceDetailsScreen extends StatelessWidget {
  final String athleteName;
  final String imageUrl;

  const RaceDetailsScreen({
    super.key,
    required this.athleteName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> raceData = [
      {'id': '1', 'date': '22/09/2024', 'distance': '100 to 200 meters'},
    ];

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent, 
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1), 
                ),
                child: CircleAvatar(
                  radius: 48, 
                  backgroundColor: Colors.grey[400], 
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.white) 
                      : null,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              athleteName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AthleteInformationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.description, color: Colors.white), 
              label: const Text(
                'Athlete Information',
                style: TextStyle(color: Colors.white), 
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, 
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black, width: 1), 
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Races:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: raceData.length,
                itemBuilder: (context, index) {
                  final race = raceData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RaceSpecificDetailsScreen(
                            raceId: race['id']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            race['date']!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            race['distance']!,
                            style: const TextStyle(fontSize: 16),
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
    );
  }
}
