import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../widgets/base_screen.dart';

class RegisterAthleteScreen extends StatefulWidget {
  final Function(String, String) onRegisterAthlete;
  final String? athleteName;
  final String? athleteImageUrl;
  final int currentIndex;

  const RegisterAthleteScreen({
    super.key,
    required this.onRegisterAthlete,
    this.athleteName,
    this.athleteImageUrl,
    this.currentIndex = 2,
  });

  @override
  _RegisterAthleteScreenState createState() => _RegisterAthleteScreenState();
}

class _RegisterAthleteScreenState extends State<RegisterAthleteScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _cpfController;
  late TextEditingController _observationsController;
  String? _imageUrl;

  bool _isCpfValid = false;
  final bool _isCpfEditable = true;
  String? _selectedGender;
  final List<String> _genders = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
    'Other'
  ];

  final MaskTextInputFormatter _dateFormatter =
      MaskTextInputFormatter(mask: '##/##/####');
  final MaskTextInputFormatter _cpfFormatter =
      MaskTextInputFormatter(mask: '###.###.###-##');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.athleteName);
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    _cpfController = TextEditingController();
    _observationsController = TextEditingController();
    _imageUrl = widget.athleteImageUrl;
    _cpfController.addListener(_validateCpf);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _cpfController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _validateCpf() {
    setState(() {
      _isCpfValid =
          _cpfController.text.replaceAll(RegExp(r'[^0-9]'), '').length == 11;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  void _registerAthlete() {
    if (_nameController.text.isNotEmpty && _isCpfValid) {
      widget.onRegisterAthlete(_nameController.text, _imageUrl ?? '');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Completed'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid name and CPF.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: widget.currentIndex,
      pageTitle: 'Register Athlete',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: _imageUrl == null
                  ? Text(
                      'Upload a profile picture +',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  : Image.file(
                      File(_imageUrl!),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              inputFormatters: [_dateFormatter],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(
                labelText: 'CPF',
                labelStyle: TextStyle(
                    color: _isCpfValid ? Colors.green : Colors.red),
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  _isCpfValid ? Icons.check_circle : Icons.error,
                  color: _isCpfValid ? Colors.green : Colors.red,
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [_cpfFormatter],
              enabled: _isCpfEditable,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              value: _selectedGender,
              items: _genders
                  .map((gender) => DropdownMenuItem(
                      value: gender, child: Text(gender)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _observationsController,
              decoration: const InputDecoration(
                labelText: 'Observations',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerAthlete,
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
