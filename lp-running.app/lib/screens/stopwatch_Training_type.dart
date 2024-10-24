import 'package:flutter/material.dart';
import 'Stopwatch_screen.dart';

class StopwatchTrainingTypeScreen extends StatefulWidget {
  final String lapTime;
  final String athlete;

  const StopwatchTrainingTypeScreen({super.key, required this.lapTime, required this.athlete});

  @override
  _StopwatchTrainingTypeScreenState createState() => _StopwatchTrainingTypeScreenState();
}

class _StopwatchTrainingTypeScreenState extends State<StopwatchTrainingTypeScreen> {
  int? _selectedTrainingIndex;
  final List<String> _trainingOptions = [
    '100 to 200 meters',
    '300 to 400 meters',
    '400 to 500 meters',
  ];
  final bool _isLoading = false;

  void _confirmTrainingSelection() {
    if (_selectedTrainingIndex != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Training successfully saved')),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const StopwatchScreen()), // Corrigido aqui
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stopwatch Training Type',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
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
                widget.lapTime,
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
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.athlete,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose Completed Training',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.red)
                      : Column(
                          children: _trainingOptions.asMap().entries.map((entry) {
                            int index = entry.key;
                            String trainingType = entry.value;
                            bool isSelected = index == _selectedTrainingIndex;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTrainingIndex = index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.red : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    trainingType,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: _confirmTrainingSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Confirm',
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
