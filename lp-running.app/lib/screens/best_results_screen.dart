import 'package:flutter/material.dart';

class BestResultsScreen extends StatefulWidget {
  const BestResultsScreen({super.key});

  @override
  _BestResultsScreenState createState() => _BestResultsScreenState();
}

class _BestResultsScreenState extends State<BestResultsScreen> {
  final List<Map<String, String>> raceData = [
    {'date': '22/09/2024', 'distance': '200m', 'time': '00:11:50'},
    {'date': '23/09/2024', 'distance': '300m', 'time': '00:11:55'},
    {'date': '24/09/2024', 'distance': '450m', 'time': '00:12:10'},
    {'date': '25/09/2024', 'distance': '500m', 'time': '00:13:00'},
    {'date': '26/09/2024', 'distance': '250m', 'time': '00:11:30'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Best Results',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Distance',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: raceData.map((race) {
                  return ResultTile(
                    date: race['date']!,
                    distance: race['distance']!,
                    time: race['time']!,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultTile extends StatelessWidget {
  final String date;
  final String distance;
  final String time;

  const ResultTile({
    super.key,
    required this.date,
    required this.distance,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              date,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: Text(
              distance,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: Text(
              time,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
