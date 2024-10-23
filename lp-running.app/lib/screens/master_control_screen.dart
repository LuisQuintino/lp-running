import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';

class MasterControlScreen extends StatefulWidget {
  const MasterControlScreen({super.key});

  @override
  _MasterControlScreenState createState() => _MasterControlScreenState();
}

class _MasterControlScreenState extends State<MasterControlScreen> {
  // Variáveis de controle das permissões
  bool _canCoachAccessCronometro = true;
  bool _canCoachAccessAtletas = false;
  bool _canCoachAccessPerfil = false;
  bool _canCoachAccessCoaches = false;
  bool _canCoachAccessBestResults = false;
  bool _canCoachAccessTrainingTypes = false;

  bool _canAlunoAccessCronometro = true;
  bool _canAlunoAccessAtletas = false;
  bool _canAlunoAccessPerfil = false;
  bool _canAlunoAccessBestResults = false;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 6,
      pageTitle: 'Controle de Acesso',
      showBackButton: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Permissões para Coach:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Cronômetro',
              value: _canCoachAccessCronometro,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessCronometro = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Atletas',
              value: _canCoachAccessAtletas,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessAtletas = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Perfil',
              value: _canCoachAccessPerfil,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessPerfil = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Coaches',
              value: _canCoachAccessCoaches,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessCoaches = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Best Results',
              value: _canCoachAccessBestResults,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessBestResults = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Tipos de Treino',
              value: _canCoachAccessTrainingTypes,
              onChanged: (value) {
                setState(() {
                  _canCoachAccessTrainingTypes = value;
                });
              },
            ),
            const Divider(),
            const Text(
              'Permissões para Aluno:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Cronômetro',
              value: _canAlunoAccessCronometro,
              onChanged: (value) {
                setState(() {
                  _canAlunoAccessCronometro = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Atletas',
              value: _canAlunoAccessAtletas,
              onChanged: (value) {
                setState(() {
                  _canAlunoAccessAtletas = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Perfil',
              value: _canAlunoAccessPerfil,
              onChanged: (value) {
                setState(() {
                  _canAlunoAccessPerfil = value;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Acesso à página de Best Results',
              value: _canAlunoAccessBestResults,
              onChanged: (value) {
                setState(() {
                  _canAlunoAccessBestResults = value;
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
              child: const Text('Salvar', style: TextStyle(fontSize: 18)),
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
