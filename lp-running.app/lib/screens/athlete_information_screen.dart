import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'best_results_screen.dart'; 
import 'export_data_screen.dart';

class AthleteInformationScreen extends StatefulWidget {
  const AthleteInformationScreen({super.key});

  @override
  _AthleteInformationScreenState createState() => _AthleteInformationScreenState();
}

class _AthleteInformationScreenState extends State<AthleteInformationScreen> {
  bool _kneeChecked = false;
  bool _spineChecked = false;
  bool _othersChecked = false;
  bool _isEditingOtherInfo = false;

  final TextEditingController _otherInfoController = TextEditingController();
  final List<String> _otherInfoHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          "Athlete's Information",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BestResultsScreen(), 
                  ),
                );
              },
              child: const Text(
                'Check best results',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: const Text('Knee'),
                    value: _kneeChecked,
                    activeColor: Colors.grey,
                    onChanged: (bool? value) {
                      setState(() {
                        _kneeChecked = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text('Spine'),
                    value: _spineChecked,
                    activeColor: Colors.grey,
                    onChanged: (bool? value) {
                      setState(() {
                        _spineChecked = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text('Others'),
                    value: _othersChecked,
                    activeColor: Colors.grey,
                    onChanged: (bool? value) {
                      setState(() {
                        _othersChecked = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Other information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (_isEditingOtherInfo)
                    TextField(
                      controller: _otherInfoController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Edit information here...',
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _otherInfoHistory.isEmpty
                          ? const [Text("No additional information")]
                          : _otherInfoHistory
                              .map((info) => Text(
                                    info,
                                    style: const TextStyle(fontSize: 14),
                                  ))
                              .toList(),
                    ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(
                        _isEditingOtherInfo ? Icons.check : Icons.edit,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_isEditingOtherInfo) {
                            if (_otherInfoController.text.isNotEmpty) {
                              String formattedDate =
                                  DateFormat('dd/MM/yyyy – kk:mm')
                                      .format(DateTime.now());
                              _otherInfoHistory.add(
                                  "${_otherInfoController.text} (Added on $formattedDate)");
                              _otherInfoController.clear();
                            }
                          }
                          _isEditingOtherInfo = !_isEditingOtherInfo;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ExportDataScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Export Data',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
