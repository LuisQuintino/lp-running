import 'package:flutter/material.dart';
import 'dart:async';
import 'stopwatch_training_type.dart';
import '../widgets/base_screen.dart';

class StopwatchScreen extends StatefulWidget {
  final List<String> athletesWithCheckIn;

  const StopwatchScreen({super.key, required this.athletesWithCheckIn});

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _timer;
  int _milliseconds = 0;
  bool _isRunning = false;
  double _progressValue = 0.0;
  Map<String, String> _athleteLapTimes = {};
  Map<String, List<String>> _lapsPerAthlete = {};
  Map<String, bool> _athleteChecked = {};
  Map<String, bool> _selectedAthletes = {};

  @override
  void initState() {
    super.initState();
    for (var athlete in widget.athletesWithCheckIn) {
      _athleteChecked[athlete] = false;
      _lapsPerAthlete[athlete] = [];
      _selectedAthletes[athlete] = false;
    }
  }

  void _startStopTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (mounted) {
          setState(() {
            _milliseconds += 10;
            _progressValue = (_milliseconds % 60000) / 60000;
          });
        }
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _milliseconds = 0;
      _isRunning = false;
      _progressValue = 0.0;
      _athleteLapTimes.clear();
      for (var athlete in _athleteChecked.keys) {
        _athleteChecked[athlete] = false;
        _lapsPerAthlete[athlete]?.clear();
        _selectedAthletes[athlete] = false;
      }
    });
  }

  String _formatTime(int milliseconds) {
    final int centiseconds = (milliseconds % 1000) ~/ 10;
    final int seconds = (milliseconds ~/ 1000) % 60;
    final int minutes = (milliseconds ~/ 60000) % 60;
    final int hours = milliseconds ~/ 3600000;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${centiseconds.toString().padLeft(2, '0')}';
  }

  void _markTimeForAthlete(String athlete) {
    final formattedTime = _formatTime(_milliseconds);
    setState(() {
      _athleteLapTimes[athlete] = formattedTime;
      _athleteChecked[athlete] = true;
      _lapsPerAthlete[athlete]?.add(formattedTime);
    });
  }

  void _navigateToTrainingType() {
    List<String> selectedAthletes = _selectedAthletes.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedAthletes.isNotEmpty) {
      final lapTime = _formatTime(_milliseconds);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StopwatchTrainingTypeScreen(
            lapTime: lapTime,
            athletes: selectedAthletes,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one athlete")),
      );
    }
  }

  void _removeLapsForAthlete(String athlete) {
    setState(() {
      _lapsPerAthlete[athlete]?.clear();
      _athleteChecked[athlete] = false;
      _selectedAthletes[athlete] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double rectangleWidth = screenWidth * 0.8;
    final double rectangleHeight = screenHeight * 0.2;

    return BaseScreen(
      currentIndex: 1,
      pageTitle: 'Stopwatch',
      child: Container(
        color: Colors.grey[200],
        height: double.infinity,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: rectangleWidth,
                      height: rectangleHeight,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        width: rectangleWidth * _progressValue,
                        height: 8,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      _formatTime(_milliseconds),
                      style: TextStyle(
                        fontSize: rectangleHeight * 0.4,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.6,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Laps',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.4,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (var athlete in widget.athletesWithCheckIn)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                  value: _selectedAthletes[athlete],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _selectedAthletes[athlete] = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _markTimeForAthlete(athlete),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          athlete,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        ...?_lapsPerAthlete[athlete]?.asMap().entries.map((entry) {
                                          int lapNumber = entry.key + 1;
                                          String lapTime = entry.value;
                                          return Text(
                                            'Lap $lapNumber: $lapTime',
                                            style: const TextStyle(fontSize: 14),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.grey),
                                  onPressed: () => _removeLapsForAthlete(athlete),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, size: 40, color: Colors.blue),
                      onPressed: _navigateToTrainingType,
                    ),
                    FloatingActionButton(
                      onPressed: _startStopTimer,
                      backgroundColor: Colors.red,
                      child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 40, color: Colors.black),
                      onPressed: _resetTimer,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
