import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // Para integração futura com banco de dados
// import 'dart:convert';

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
  @override
  void initState() {
    super.initState();
    
  }

  void _confirmTrainingSelection() {
    if (_selectedTrainingIndex != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Treino selecionado: ${_trainingOptions[_selectedTrainingIndex!]}')),
      );
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
            // Display do tempo da volta
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
                    'Choose training type',
                    style: TextStyle(fontSize: 24, color: Colors.white), 
                  ),
                  const SizedBox(height: 16),

                  // Lista de treinos (exemplo fixo, substituir futuramente com dados do banco)
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

            
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.red, size: 40),
              onPressed: _confirmTrainingSelection,
            ),
          ],
        ),
      ),
    );
  }
}
