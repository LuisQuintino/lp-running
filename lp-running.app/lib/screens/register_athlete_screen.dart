import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterAthleteScreen extends StatefulWidget {
  final Function(String, String) onRegisterAthlete;
  final String? athleteName;
  final String? athleteImageUrl;
  final String? athleteEmail;
  final String? athleteCpf;
  final String? athleteDob;
  final String? athleteObservations;
  final String? athleteGender;
  final String? athleteCoach;

  const RegisterAthleteScreen({
    super.key,
    required this.onRegisterAthlete,
    this.athleteName,
    this.athleteImageUrl,
    this.athleteEmail,
    this.athleteCpf,
    this.athleteDob,
    this.athleteObservations,
    this.athleteGender,
    this.athleteCoach,
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
  String? _selectedGender;
  String? _selectedCoach;
  List<String> _coaches = [];

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
    _emailController = TextEditingController(text: widget.athleteEmail);
    _dobController = TextEditingController(text: widget.athleteDob);
    _cpfController = TextEditingController(text: widget.athleteCpf);
    _observationsController =
        TextEditingController(text: widget.athleteObservations);
    _imageUrl = widget.athleteImageUrl;
    _selectedGender = widget.athleteGender;
    _selectedCoach = widget.athleteCoach;

    _fetchCoaches();
  }

  Future<void> _fetchCoaches() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/coaches'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _coaches = data
              .where((coach) => coach['active'] == true)
              .map<String>((coach) => coach['name'] as String)
              .toList();
        });
      } else {
        throw Exception('Erro ao carregar coaches');
      }
    } catch (error) {
      print("Erro ao buscar coaches: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar coaches. Verifique a conexão.'),
        ),
      );
    }
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  void _registerAthlete() async {
  if (_nameController.text.isEmpty || _cpfController.text.isEmpty || _emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preencha todos os campos obrigatórios (nome, CPF e email).'),
      ),
    );
    return;
  }

  final athleteData = {
    "name": _nameController.text,
    "email": _emailController.text,
    "cpf": _cpfController.text,
    "dob": _dobController.text.isNotEmpty
        ? _dobController.text.split('/').reversed.join('-') // Converte para formato ISO
        : null,
    "observations": _observationsController.text,
    "imageUrl": _imageUrl, // Substituir por URL real após upload
    "gender": _selectedGender,
    "coach": _selectedCoach,
    "active": true,
  };

  try {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/athletes'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(athleteData),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atleta registrado com sucesso!'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      print('Erro ao registrar atleta: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao registrar atleta. Verifique os dados e tente novamente.'),
        ),
      );
    }
  } catch (error) {
    print('Erro na requisição: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Erro ao conectar com o servidor. Verifique a conexão.'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Register Athlete',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
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
              decoration: const InputDecoration(
                labelText: 'CPF',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [_cpfFormatter],
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
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Coaches',
                border: OutlineInputBorder(),
              ),
              value: _selectedCoach,
              items: _coaches.isEmpty
                  ? [const DropdownMenuItem(value: null, child: Text("No active coaches"))]
                  : _coaches
                      .map((coach) => DropdownMenuItem(value: coach, child: Text(coach)))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCoach = value;
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
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
