import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';

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
  late String _grupoSelecionado;
  bool _modoEdicao = false;
  final QuillController _controller = QuillController.basic();

  final List<String> _gruposDisponiveis = ['Pessoal', 'Trabalho', 'Estudos', 'Outros'];

  @override
  void initState() {
    super.initState();
    _controller.document = Document.fromJson(jsonDecode(widget.nota['texto']));
    _controller.readOnly = true;
    _tituloController = TextEditingController(text: widget.nota['titulo']);
    _grupoSelecionado = widget.nota['grupo'];
  }

  Future<void> salvarAlteracoes() async {
    await firebaseService.atualizarNota(
      id: widget.nota['id'],
      titulo: _tituloController.text,
      texto: jsonEncode(_controller.document.toDelta().toJson()),
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
              _controller.readOnly = !_controller.readOnly;
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
            _modoEdicao ? QuillSimpleToolbar(
              controller: _controller,
              config: const QuillSimpleToolbarConfig(),
            ) : const SizedBox(),
            Expanded(
              child: QuillEditor.basic(
                controller: _controller,
                config: const QuillEditorConfig(
                  customStyles: DefaultStyles(
                    paragraph: DefaultTextBlockStyle(
                        TextStyle(color: Colors.white, fontSize: 16),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        BoxDecoration()),
                    h1: DefaultTextBlockStyle(
                        TextStyle(color: Colors.white, fontSize: 24),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        BoxDecoration()),
                    h2: DefaultTextBlockStyle(
                        TextStyle(color: Colors.white, fontSize: 20),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        BoxDecoration()),
                    h3: DefaultTextBlockStyle(
                        TextStyle(color: Colors.white, fontSize: 18),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        BoxDecoration()),
                    quote: DefaultTextBlockStyle(
                        TextStyle(color: Colors.white, fontSize: 16),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        BoxDecoration()),
                    lists: DefaultListBlockStyle(
                        TextStyle(color: Colors.white, fontSize: 16),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        BoxDecoration(),
                        null // Add the missing argument (e.g., null or appropriate value)
                        ),
                  ),
                ),
              ),
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
