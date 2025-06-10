
import 'package:flutter/material.dart';
import 'package:noted/services/firebase_service.dart';

class CriarNota extends StatefulWidget {
  const CriarNota({super.key});

  @override
  State<CriarNota> createState() => _CriarNotaState();
}

class _CriarNotaState extends State<CriarNota> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _textoController = TextEditingController();
  String _grupoSelecionado = 'Pessoal';

  final List<String> _grupos = ['Pessoal', 'Trabalho', 'Estudos', 'Outros'];
  final firebaseService = FirebaseService();

  Future<void> salvarNota() async {
    await firebaseService.salvarNota(
      titulo: _tituloController.text,
      texto: _textoController.text,
      grupo: _grupoSelecionado,
    );
    Navigator.pop(context); // Volta para a HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Nova Nota',style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),),
        iconTheme: const IconThemeData(color: Colors.purpleAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.purpleAccent),
            onPressed: salvarNota,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Título',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
            DropdownButton<String>(
              dropdownColor: Colors.grey[900],
              value: _grupoSelecionado,
              items: _grupos.map((String grupo) {
                return DropdownMenuItem<String>(
                  value: grupo,
                  child: Text(grupo, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? novoGrupo) {
                setState(() {
                  _grupoSelecionado = novoGrupo!;
                });
              },
            ),
            Expanded(
              child: TextField(
                controller: _textoController,
                maxLines: null,
                expands: true,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(
                  hintText: 'Escreva sua nota...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
