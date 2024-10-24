import 'package:flutter/material.dart';
import 'dart:async';
import 'stopwatch_assignment.dart'; 
import '../widgets/base_screen.dart'; 

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _timer;
  int _milliseconds = 0; 
  bool _isRunning = false;
  final List<String> _lapTimes = [];
  double _circleProgress = 0.0; 

  void _startStopTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (mounted) { 
          setState(() {
            _milliseconds += 10; 
            _circleProgress = (_milliseconds % 60000) / 60000; 
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
      _lapTimes.clear();
      _circleProgress = 0.0; 
    });
  }

  void _addLapTime() {
    final formattedTime = _formatTime(_milliseconds);
    setState(() {
      _lapTimes.add(formattedTime); 
      _circleProgress = 0.0; 
    });
  }

  String _formatTime(int milliseconds) {
    final int centiseconds = (milliseconds % 1000) ~/ 10; 
    final int minutes = (milliseconds ~/ 60000) % 60; 
    final int hours = (milliseconds ~/ 3600000); 
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${centiseconds.toString().padLeft(2, '0')}';
  }

  void _assignAthlete(String lap) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StopwatchAssignment(lapTime: lap),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return BaseScreen(
      currentIndex: 1, 
      pageTitle: 'Stopwatch', 
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
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black, 
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                    child: CircularProgressIndicator(
                      value: _circleProgress,
                      strokeWidth: 12,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      backgroundColor: Colors.black,
                    ),
                  ),
                  Text(
                    _formatTime(_milliseconds),
                    style: TextStyle(
                      fontSize: screenWidth * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                width: screenWidth * 0.4,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Laps',
                    style: TextStyle(
                      fontSize: 24,
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
                      for (var i = 0; i < _lapTimes.length; i++)
                        Container(
                          width: double.infinity, 
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6), 
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                            children: [
                              Text(
                                '${i + 1}. ${_lapTimes[i]}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: 24, 
                                  color: Colors.red, 
                                ),
                                onPressed: () => _assignAthlete(_lapTimes[i]),
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
                    icon: const Icon(Icons.check_circle, size: 40, color: Colors.green),
                    onPressed: _addLapTime,
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
    );
  }
}
