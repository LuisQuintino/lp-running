import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'dart:io';
//import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../widgets/base_screen.dart';

class RegisterTrainingTypeScreen extends StatefulWidget {
  final Function(String, String, String) onRegisterTraining;

  const RegisterTrainingTypeScreen({
    super.key,
    required this.onRegisterTraining,
  });

  @override
  _RegisterTrainingTypeScreenState createState() =>
      _RegisterTrainingTypeScreenState();
}

class _RegisterTrainingTypeScreenState
    extends State<RegisterTrainingTypeScreen> {
  final TextEditingController _trainingTypeController =
      TextEditingController();
  final TextEditingController _averageDurationController =
      TextEditingController();
  final List<String> _difficultyLevels = [
    'Basic',
    'Medium',
    'Advanced',
    'Extreme'
  ];
  String? _selectedDifficultyLevel;

  @override
  void dispose() {
    _trainingTypeController.dispose();
    _averageDurationController.dispose();
    super.dispose();
  }

  void _registerTrainingType() {
    if (_trainingTypeController.text.isNotEmpty &&
        _selectedDifficultyLevel != null &&
        _averageDurationController.text.isNotEmpty) {
      widget.onRegisterTraining(
        _trainingTypeController.text,
        _selectedDifficultyLevel!,
        _averageDurationController.text,
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 2,
      pageTitle: 'Register Training Type',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _trainingTypeController,
              decoration: const InputDecoration(
                labelText: 'Training Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Difficulty Level',
                border: OutlineInputBorder(),
              ),
              value: _selectedDifficultyLevel,
              items: _difficultyLevels.map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDifficultyLevel = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _averageDurationController,
              decoration: const InputDecoration(
                labelText: 'Average Duration',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerTrainingType,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
