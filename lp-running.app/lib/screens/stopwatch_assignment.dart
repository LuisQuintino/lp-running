import 'package:flutter/material.dart';
import 'dart:async';
import 'stopwatch_training_type.dart'; 

class StopwatchAssignment extends StatefulWidget {
  final String lapTime; 

  const StopwatchAssignment({super.key, required this.lapTime}); 

  @override
  _StopwatchAssignmentState createState() => _StopwatchAssignmentState();
}

class _StopwatchAssignmentState extends State<StopwatchAssignment> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _formattedTime = '00:00:00';
  int? _selectedAthleteIndex;

  final List<Map<String, dynamic>> _athletes = [
    {'name': 'Athlete 001', 'active': true},
    {'name': 'Athlete 002', 'active': true},
    {'name': 'Athlete 003', 'active': true},
  ];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _startTimer();
    _formattedTime = widget.lapTime; 
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          _formattedTime = _formatElapsedTime(_stopwatch.elapsed);
        });
      }
    });
  }

  String _formatElapsedTime(Duration elapsed) {
    String hours = (elapsed.inHours).toString().padLeft(2, '0');
    String minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _assignAthlete(int index) {
    setState(() {
      _selectedAthleteIndex = index;
    });
    _navigateToTrainingTypeScreen(_athletes[index]['name']!); 
  }

  void _navigateToTrainingTypeScreen(String athleteName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StopwatchTrainingTypeScreen(
          lapTime: widget.lapTime, 
          athlete: athleteName, 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stopwatch Assignment',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.grey[850], 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Text(
                _formattedTime,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800], 
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Assign to',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  // List of Athletes
                  ..._athletes.asMap().entries.map((entry) {
                    int index = entry.key;
                    String athleteName = entry.value['name'];
                    bool isSelected = index == _selectedAthleteIndex;
                    return GestureDetector(
                      onTap: () => _assignAthlete(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.red : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            athleteName,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
