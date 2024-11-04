import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stopwatch_screen.dart';
import '../widgets/base_screen.dart';

class AthleteCheckInScreen extends StatefulWidget {
  const AthleteCheckInScreen({super.key});

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
        SnackBar(content: Text("Error loading athletes")),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Check-in confirmed for $athleteName")),
    );
  }

  void _confirmAllAndNavigate() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StopwatchScreen(
          athletesWithCheckIn: _confirmedAthletes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 2,
      pageTitle: 'Athletes Check-In',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Athlete',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterAthletes,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredAthletes.isEmpty
                  ? Center(
                      child: Text(
                        "No athletes found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredAthletes.length,
                      itemBuilder: (context, index) {
                        final athlete = _filteredAthletes[index];
                        final isConfirmed = _confirmedAthletes.contains(athlete);
                        return ListTile(
                          title: Text(athlete),
                          trailing: Icon(
                            isConfirmed ? Icons.check_circle : Icons.check_circle_outline,
                            color: isConfirmed ? Colors.green : null,
                          ),
                          onTap: () {
                            _confirmCheckIn(athlete);
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmedAthletes.isEmpty ? null : _confirmAllAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
