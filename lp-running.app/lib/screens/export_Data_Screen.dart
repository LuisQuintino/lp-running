import 'package:flutter/material.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  _ExportDataScreenState createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  bool _recordsChecked = false;
  bool _bestTimesChecked = false;
  bool _trainingDaysChecked = false;
  bool _personalInfoChecked = false;

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _exportData() {
    final email = _emailController.text;
    if (email.isEmpty || !_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email sent successfully!'),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Export Data',
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
            _buildCheckboxSection(context),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 24),
            _buildExportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCheckboxTile('Records', _recordsChecked, (value) {
            setState(() {
              _recordsChecked = value ?? false;
            });
          }),
          _buildCheckboxTile('Best times', _bestTimesChecked, (value) {
            setState(() {
              _bestTimesChecked = value ?? false;
            });
          }),
          _buildCheckboxTile('Training days', _trainingDaysChecked, (value) {
            setState(() {
              _trainingDaysChecked = value ?? false;
            });
          }),
          _buildCheckboxTile('Personal information', _personalInfoChecked, (value) {
            setState(() {
              _personalInfoChecked = value ?? false;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email address',
        border: OutlineInputBorder(),
        hintText: 'Enter your email address',
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _exportData,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.black, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Export Data',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
