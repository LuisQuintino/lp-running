import 'package:flutter/material.dart';

class BestResultsScreen extends StatelessWidget {
  const BestResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Best Results',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.grey[800], 
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Títulos das colunas
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Distance',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 16), // Espaçamento entre os títulos
                Expanded(
                  child: Text(
                    'Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end, // Alinhado à direita
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Exemplo de dados (deve ser substituído pela busca no banco)
            Expanded(
              child: ListView(
                children: const [
                  ResultTile(distance: '200m', time: '00:11:50'),
                  ResultTile(distance: '300m', time: '00:11:55'),
                  ResultTile(distance: '450m', time: '00:12:10'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultTile extends StatelessWidget {
  final String distance;
  final String time;

  const ResultTile({super.key, 
    required this.distance,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200], 
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              distance,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: 16), 
          Expanded(
            child: Text(
              time,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.end, 
            ),
          ),
        ],
      ),
    );
  }
}
