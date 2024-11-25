import 'package:flutter/material.dart';
import 'package:lp_runningflutter/screens/athlete_information_screen.dart';

class RaceDetailsScreen extends StatelessWidget {
  final String athleteName;
  final String imageUrl;
  final String athleteDob;
  final String athleteEmail;
  final Function(String name, String email, String dob) onRegisterAthlete;

  const RaceDetailsScreen({
    super.key,
    required this.athleteName,
    required this.imageUrl,
    required this.athleteDob,
    required this.athleteEmail,
    required this.onRegisterAthlete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Race Details'),
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AthleteInformationScreen(
                    onRegisterAthlete: onRegisterAthlete,
                    athleteName: athleteName,
                    athleteEmail: athleteEmail,
                    athleteDob: athleteDob,
                  ),
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
        ],
      ),
    );
  }
}
