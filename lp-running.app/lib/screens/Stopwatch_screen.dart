import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stopwatch_training_type.dart';
import '../widgets/base_screen.dart';
import 'athlete_check_in_screen.dart';

class StopwatchScreen extends StatefulWidget {
  final List<String> athletesWithCheckIn;
  final Map<String, List<String>> lapsPerAthlete;
  final bool showAthleteCheckInPopup;

  const StopwatchScreen({
    super.key,
    required this.athletesWithCheckIn,
    this.lapsPerAthlete = const {},
    this.showAthleteCheckInPopup = true,
  });

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _timer;
  int _milliseconds = 0;
  bool _isRunning = false;
  double _progressValue = 0.0;
  Map<String, String> _athleteLapTimes = {};
  late Map<String, List<String>> _lapsPerAthlete;
  Map<String, bool> _athleteChecked = {};
  Map<String, bool> _selectedAthletes = {};
  String _searchQuery = "";
  List<String> _allAthletes = [];

  @override
  void initState() {
    super.initState();
    _lapsPerAthlete = Map<String, List<String>>.from(widget.lapsPerAthlete);
    for (var athlete in widget.athletesWithCheckIn) {
      _athleteChecked[athlete] = false;
      _lapsPerAthlete[athlete] ??= [];
      _selectedAthletes[athlete] = false;
    }

    if (widget.showAthleteCheckInPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _showAthleteCheckInDialog();
        });
      });
    }
  }

  Future<void> _fetchAthletes() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/athletes'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _allAthletes = data.map((athlete) => athlete['name'].toString()).toList();
        });
      } else {
        throw Exception('Failed to load athletes');
      }
    } catch (e) {
      print('Error fetching athletes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading athletes")),
      );
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

  void _resetAll() {
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

  void _selectAllAthletes() {
    setState(() {
      for (var athlete in _selectedAthletes.keys) {
        _selectedAthletes[athlete] = true;
      }
    });
  }

  void _deleteSelectedAthletes() {
    setState(() {
      // Remove apenas os atletas selecionados e limpa os laps deles
      _selectedAthletes.forEach((athlete, isSelected) {
        if (isSelected) {
          _lapsPerAthlete[athlete]?.clear();
        }
      });
      _selectedAthletes.removeWhere((athlete, isSelected) => isSelected);
      _resetAll(); // Zera o cronômetro ao deletar os selecionados
    });
  }

  void _deleteSingleAthlete(String athlete) {
    setState(() {
      _selectedAthletes.remove(athlete);
      _lapsPerAthlete.remove(athlete);
    });
  }

  String _formatTime(int milliseconds) {
    final int centiseconds = (milliseconds % 1000) ~/ 10;
    final int seconds = (milliseconds ~/ 1000) % 60;
    final int minutes = (milliseconds ~/ 60000) % 60;
    final int hours = milliseconds ~/ 3600000;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${centiseconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${centiseconds.toString().padLeft(2, '0')}';
    }
  }

  void _showAthleteCheckInDialog() async {
    await _fetchAthletes();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.7,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search Athletes',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: _allAthletes
                          .where((athlete) => athlete.toLowerCase().contains(_searchQuery))
                          .map((athlete) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAthletes[athlete] = !(_selectedAthletes[athlete] ?? false);
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 70, // Definindo altura dos itens para 60-70 pixels
                                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    border: _selectedAthletes[athlete] == true
                                        ? Border.all(color: Colors.green, width: 2)
                                        : Border.all(color: Colors.transparent, width: 2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        athlete,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Icon(
                                        _selectedAthletes[athlete] == true
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: _selectedAthletes[athlete] == true
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm All Athletes'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _recordLapForAthlete(String athlete) {
    final lapTime = _formatTime(_milliseconds);
    setState(() {
      _lapsPerAthlete[athlete]?.add(lapTime);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lap recorded for $athlete: $lapTime')),
    );
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _formatTime(_milliseconds),
                        style: TextStyle(
                          fontSize: rectangleHeight * 0.4,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_box, size: 30, color: Colors.black),
                      onPressed: _selectAllAthletes,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 120,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: _startStopTimer,
                        child: Text(
                          _isRunning ? 'Stop' : 'Start',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 30, color: Colors.black),
                      onPressed: _deleteSelectedAthletes,
                    ),
                  ],
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
                        for (var athlete in _selectedAthletes.keys)
                          GestureDetector(
                            onTap: () => _recordLapForAthlete(athlete),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: _selectedAthletes[athlete] == true
                                    ? Border.all(color: Colors.green, width: 2)
                                    : Border.all(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                        child: Text(
                                          athlete,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 24,
                                          color: _selectedAthletes[athlete] == true ? Colors.green : Colors.red,
                                        ),
                                        onPressed: () => _deleteSingleAthlete(athlete),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (_lapsPerAthlete[athlete] != null)
                                    for (int i = 0; i < _lapsPerAthlete[athlete]!.length; i++)
                                      Text(
                                        'Lap ${i + 1}: ${_lapsPerAthlete[athlete]![i]}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, size: 30, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StopwatchTrainingTypeScreen(
                            lapsPerAthlete: _lapsPerAthlete,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
