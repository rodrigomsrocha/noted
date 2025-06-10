
import 'package:flutter/material.dart';
import 'package:noted/services/firebase_service.dart';

class NotaHabito extends StatefulWidget {
  final Map<String, dynamic> nota;

  const NotaHabito({super.key, required this.nota});

  @override
  State<NotaHabito> createState() => _NotaHabitoState();
}

class _NotaHabitoState extends State<NotaHabito> {
  final firebaseService = FirebaseService();

  late TextEditingController _tituloController;
  late TextEditingController _textoController;
  late String _grupoSelecionado;
  bool _modoEdicao = false;

  final List<String> _gruposDisponiveis = ['Pessoal', 'Trabalho', 'Estudos', 'Outros'];

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.nota['titulo']);
    _textoController = TextEditingController(text: widget.nota['texto']);
    _grupoSelecionado = widget.nota['grupo'];
  }

  Future<void> salvarAlteracoes() async {
    await firebaseService.atualizarNota(
      id: widget.nota['id'],
      titulo: _tituloController.text,
      texto: _textoController.text,
      grupo: _grupoSelecionado,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B14),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purpleAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Noted!',
          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_modoEdicao ? Icons.save : Icons.edit, color: Colors.purpleAccent),
            onPressed: () {
              if (_modoEdicao) {
                salvarAlteracoes();
              } else {
                setState(() {
                  _modoEdicao = true;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _modoEdicao
                ? TextField(
                    controller: _tituloController,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    decoration: const InputDecoration(
                      hintText: 'Título da nota',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    widget.nota['titulo'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(height: 16),
            _modoEdicao
                ? DropdownButton<String>(
                    dropdownColor: Colors.grey[900],
                    value: _grupoSelecionado,
                    items: _gruposDisponiveis.map((String grupo) {
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
                  )
                : Text(
                    "Grupo: ${widget.nota['grupo']}",
                    style: const TextStyle(color: Colors.white70),
                  ),
            const SizedBox(height: 16),
            _modoEdicao
                ? TextField(
                    controller: _textoController,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Digite o conteúdo da nota...',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    widget.nota['texto'],
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
            const SizedBox(height: 16),
            if (widget.nota['imagemUrl'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.nota['imagemUrl'],
                  fit: BoxFit.contain,
                  height: 300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
