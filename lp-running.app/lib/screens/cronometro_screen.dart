import 'package:flutter/material.dart';
import 'dart:async';
import 'stopwatch_assignment.dart'; 
import '../widgets/base_screen.dart'; 

class CronometroScreen extends StatefulWidget {
  const CronometroScreen({super.key});

  @override
  _CronometroScreenState createState() => _CronometroScreenState();
}

class _CronometroScreenState extends State<CronometroScreen> {
  Timer? _timer;
  int _milliseconds = 0; 
  bool _isRunning = false;
  final List<String> _lapTimes = [];
  double _circleProgress = 0.0; 

  void _startStopTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _milliseconds += 100;
          _circleProgress = (_milliseconds % 60000) / 60000; 
        });
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
    return BaseScreen(
      currentIndex: 1, 
      pageTitle: 'Cronômetro', 
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Stack(
              alignment: Alignment.center,
              children: [
                
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black, 
                  ),
                ),
                
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _circleProgress,
                    strokeWidth: 12,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                    backgroundColor: Colors.black,
                  ),
                ),
                // Texto do cronômetro
                Text(
                  _formatTime(_milliseconds),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, 
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            
            Container(
              width: 100,
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
              width: 300,
              height: 250, 
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
                      GestureDetector(
                        onTap: () => _assignAthlete(_lapTimes[i]), 
                        child: Container(
                          width: double.infinity, 
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), 
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}. ${_lapTimes[i]}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            
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
                  child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 30),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 40, color: Colors.red),
                  onPressed: _resetTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
