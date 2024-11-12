import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AthleteCheckInScreen extends StatefulWidget {
  final void Function(List<String>) onConfirm;

  const AthleteCheckInScreen({Key? key, required this.onConfirm}) : super(key: key);

  @override
  _AthleteCheckInScreenState createState() => _AthleteCheckInScreenState();
}

class _AthleteCheckInScreenState extends State<AthleteCheckInScreen> {
  String _searchQuery = "";
  List<String> _checkedInAthletes = [];
  List<String> _filteredAthletes = [];
  List<String> _confirmedAthletes = [];

  @override
  void initState() {
    super.initState();
    _fetchAthletes();
  }

  Future<void> _fetchAthletes() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/athletes'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _checkedInAthletes = data.map((athlete) => athlete['name'].toString()).toList();
          _filteredAthletes = List.from(_checkedInAthletes);
        });
      } else {
        throw Exception('Failed to load athletes');
      }
    } catch (error) {
      print('Error fetching athletes: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading athletes")),
      );
    }
  }

  void _filterAthletes(String query) {
    setState(() {
      _searchQuery = query;
      _filteredAthletes = _checkedInAthletes
          .where((athlete) => athlete.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _confirmCheckIn(String athleteName) {
    setState(() {
      if (!_confirmedAthletes.contains(athleteName)) {
        _confirmedAthletes.add(athleteName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Athlete',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _filterAthletes,
            ),
            const SizedBox(height: 16),
            _filteredAthletes.isEmpty
                ? const Center(
                    child: Text(
                      "No athletes found.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredAthletes.length,
                      itemBuilder: (context, index) {
                        final athlete = _filteredAthletes[index];
                        final isConfirmed = _confirmedAthletes.contains(athlete);
                        return ListTile(
                          title: Text(
                            athlete,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            isConfirmed ? Icons.check_circle : Icons.circle_outlined,
                            color: isConfirmed ? Colors.green : Colors.grey,
                          ),
                          onTap: () {
                            _confirmCheckIn(athlete);
                          },
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmedAthletes.isEmpty
                    ? null
                    : () {
                        widget.onConfirm(_confirmedAthletes);
                        Navigator.of(context).pop();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text(
                  "Confirm All and Start Stopwatch",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
