import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class MasterControlScreen extends StatefulWidget {
  const MasterControlScreen({super.key});

  @override
  _MasterControlScreenState createState() => _MasterControlScreenState();
}

class _MasterControlScreenState extends State<MasterControlScreen> {
  bool _canCoachAccessStopwatch = true;
  bool _canCoachAccessAthletes = false;
  bool _canCoachAccessProfile = false;
  bool _canCoachAccessCoaches = false;
  bool _canCoachAccessBestResults = false;
  bool _canCoachAccessTrainingTypes = false;

  bool _canStudentAccessStopwatch = true;
  bool _canStudentAccessAthletes = false;
  bool _canStudentAccessProfile = false;
  bool _canStudentAccessBestResults = false;

  final TextEditingController _emailOrNameController = TextEditingController();
  String? _generatedPassword;
  bool _isGenerateButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailOrNameController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _emailOrNameController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isGenerateButtonEnabled = _emailOrNameController.text.isNotEmpty;
    });
  }

  String _generateRandomPassword(int length) {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void _showPasswordPopup(String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Text(
            'New Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                password,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: password));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password copied')),
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 6,
      pageTitle: 'Access Control',
      showBackButton: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Permissions for Coach:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildSwitchTile(
              title: 'Access to Stopwatch page',
              value: _canCoachAccessStopwatch,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessStopwatch = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Access to Athletes page',
              value: _canCoachAccessAthletes,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessAthletes = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Access to Profile page',
              value: _canCoachAccessProfile,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessProfile = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Access to Coaches page',
              value: _canCoachAccessCoaches,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessCoaches = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Access to Best Results page',
              value: _canCoachAccessBestResults,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessBestResults = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Access to Training Types page',
              value: _canCoachAccessTrainingTypes,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessTrainingTypes = value;
                });
              },
            ),
            const Divider(),
            const Text(
              'Permissions for Student:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildSwitchTile(
              title: 'Access to Stopwatch page',
              value: _canStudentAccessStopwatch,
              onChanged: (value) {
                setState(() {
                  _canStudentAccessStopwatch = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Access to Athletes page',
              value: _canStudentAccessAthletes,
              onChanged: (value) {
                setState(() {
                  _canStudentAccessAthletes = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Access to Profile page',
              value: _canStudentAccessProfile,
              onChanged: (value) {
                setState(() {
                  _canStudentAccessProfile = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Access to Best Results page',
              value: _canStudentAccessBestResults,
              onChanged: (value) {
                setState(() {
                  _canStudentAccessBestResults = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: Colors.black, width: 1.0),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Save', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              color: Colors.grey[800],
              alignment: Alignment.center,
              child: const Text(
                'New Password',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailOrNameController,
              decoration: InputDecoration(
                labelText: 'Enter email or full name',
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isGenerateButtonEnabled
                  ? () {
                      setState(() {
                        _generatedPassword = _generateRandomPassword(8);
                      });
                      _showPasswordPopup(_generatedPassword!);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _isGenerateButtonEnabled ? Colors.red : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: Colors.black, width: 1.0),
              ),
              child: const Text('Generate Password'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      activeColor: Colors.green,
      inactiveThumbColor: Colors.grey.shade400,
      activeTrackColor: Colors.lightGreen.shade200,
      inactiveTrackColor: Colors.grey.shade300,
      onChanged: onChanged,
    );
  }
}
