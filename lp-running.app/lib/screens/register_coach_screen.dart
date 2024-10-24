import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterCoachScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onRegister;
  final Map<String, dynamic>? coach;
  final bool isEditing;

  const RegisterCoachScreen({
    super.key,
    required this.onRegister,
    this.coach,
    this.isEditing = false,
  });

  @override
  _RegisterCoachScreenState createState() => _RegisterCoachScreenState();
}

class _RegisterCoachScreenState extends State<RegisterCoachScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cpfController;
  late TextEditingController _dobController;

  bool? _isCpfValid;
  String? _selectedRole;

  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final _dobFormatter = MaskTextInputFormatter(mask: '##/##/####');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.coach?['name'] ?? '');
    _emailController = TextEditingController(text: widget.coach?['email'] ?? '');
    _phoneController = TextEditingController(text: widget.coach?['phone'] ?? '');
    _cpfController = TextEditingController(text: widget.coach?['cpf'] ?? '');
    _dobController = TextEditingController(text: widget.coach?['dob'] ?? '');
    _selectedRole = widget.coach?['role'];
    _isCpfValid = widget.isEditing ? _validateCpf(_cpfController.text) : null;
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?$');
    return emailRegex.hasMatch(email);
  }

  bool _validateCpf(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11 || RegExp(r'^(.)\1*$').hasMatch(cpf)) return false;
    int calculateVerifierDigit(String str, int weight) {
      int sum = 0;
      for (int i = 0; i < str.length; i++) {
        sum += int.parse(str[i]) * weight--;
      }
      int remainder = sum % 11;
      return remainder < 2 ? 0 : 11 - remainder;
    }

    int digit1 = calculateVerifierDigit(cpf.substring(0, 9), 10);
    int digit2 = calculateVerifierDigit(cpf.substring(0, 10), 11);
    return digit1 == int.parse(cpf[9]) && digit2 == int.parse(cpf[10]);
  }

  void _registerCoach() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _cpfController.text.isEmpty ||
        !_isCpfValid! ||
        !_isEmailValid(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill out the name, email, and CPF correctly.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newCoach = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'cpf': _cpfController.text,
      'dob': _dobController.text,
      'role': _selectedRole,
      'active': true,
    };

    widget.onRegister(newCoach);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful.'),
        backgroundColor: Colors.red,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Register Coach',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              if (!_isEmailValid(_emailController.text) &&
                  _emailController.text.isNotEmpty)
                const Text(
                  'Invalid format. Use name@example.com or name@name.com.br',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _cpfController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'CPF',
                  labelStyle: const TextStyle(color: Colors.black),
                  hintText: '000.000.000-00',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: _isCpfValid == null
                      ? null
                      : _isCpfValid == true
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.cancel, color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [_cpfFormatter],
                onChanged: (value) {
                  setState(() {
                    _isCpfValid = _validateCpf(value);
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dobController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  hintText: '00/00/0000',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.datetime,
                inputFormatters: [_dobFormatter],
              ),
              const SizedBox(height: 16),
              const Text('Select Role:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Center(child: Text('Admin')),
                      value: 'Admin',
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Center(child: Text('Coach')),
                      value: 'Coach',
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Center(child: Text('Master')),
                      value: 'Master',
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _registerCoach,
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
