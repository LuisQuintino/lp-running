import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as excel;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // Necessário para usar kIsWeb
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Para visualizar ou salvar PDF
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Importação universal para Web
import 'package:universal_html/html.dart' as html;

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  _ExportDataScreenState createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  bool _recordsChecked = false;
  List<dynamic> _exportData = [];

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/coaches'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _exportData = data;
        });
      } else {
        throw Exception('Falha ao carregar os dados');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  // Função para exportar dados como PDF
  Future<void> _exportDataPdf() async {
    final pdf = pw.Document();

    // Adicionando conteúdo ao PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Exported Data',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Best Time', 'Training Days'],
              data: _recordsChecked
                  ? _exportData.map((record) {
                      return [
                        record['best_time']?.toString() ?? '',
                        record['training_days']?.toString() ?? '',
                      ];
                    }).toList()
                  : [],
            ),
          ],
        ),
      ),
    );

    if (kIsWeb) {
      // Para Web
      final bytes = await pdf.save();
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'exported_data.pdf'
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      try {
        // Para Android/iOS
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/exported_data.pdf';
        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos como PDF nos documentos!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar o arquivo: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Records'),
              value: _recordsChecked,
              onChanged: (value) {
                setState(() {
                  _recordsChecked = value ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _exportDataCsv,
              child: const Text('Export as CSV'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _exportDataExcel,
              child: const Text('Export as Excel'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _exportDataPdf,
              child: const Text('Export as PDF'),
            ),
          ],
        ),
      ),
    );
  }

  // As funções _exportDataCsv e _exportDataExcel permanecem inalteradas
  Future<void> _exportDataCsv() async {
    // (Função existente no seu código)
  }

  Future<void> _exportDataExcel() async {
    // (Função existente no seu código)
  }
}
