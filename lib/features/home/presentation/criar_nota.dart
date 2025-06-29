import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:noted/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CriarNota extends StatefulWidget {
  const CriarNota({super.key});

  @override
  State<CriarNota> createState() => _CriarNotaState();
}

class _CriarNotaState extends State<CriarNota> {
  final TextEditingController _tituloController = TextEditingController();
  final QuillController _controller = QuillController.basic();
  String _grupoSelecionado = 'Pessoal';

  final List<String> _grupos = ['Pessoal', 'Trabalho', 'Estudos', 'Outros'];
  final firebaseService = FirebaseService();

  String? imagemUrl;

  Future<void> salvarNota() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    await firebaseService.salvarNota(
      uid: user.uid,
      titulo: _tituloController.text,
      texto: jsonEncode(_controller.document.toDelta().toJson()),
      imagemUrl: imagemUrl,
      grupo: _grupoSelecionado,
    );
    Navigator.pop(context); // Volta para a HomeScreen
  }

  Future<void> selecionarImagem() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      final bytes = result.files.first.bytes;
      if (bytes != null) {
        final base64Image = base64Encode(bytes);
        final url = await firebaseService.uploadImagem(base64Image);
        if (url != null) {
          setState(() {
            imagemUrl = url;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Nova Nota',
          style: TextStyle(
              color: Colors.purpleAccent, fontWeight: FontWeight.bold),
        ),
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
                  child:
                      Text(grupo, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? novoGrupo) {
                setState(() {
                  _grupoSelecionado = novoGrupo!;
                });
              },
            ),
            QuillSimpleToolbar(
              controller: _controller,
              config: const QuillSimpleToolbarConfig(
                  buttonOptions: QuillSimpleToolbarButtonOptions(
                      base: QuillToolbarBaseButtonOptions(
                          iconTheme: QuillIconTheme(
                              iconButtonUnselectedData: IconButtonData(
                                  color: Colors.white,
                                  disabledColor:
                                      CupertinoColors.inactiveGray))),
                      selectHeaderStyleDropdownButton:
                          QuillToolbarSelectHeaderStyleDropdownButtonOptions(
                              textStyle: TextStyle(color: Colors.white)),
                      fontSize: QuillToolbarFontSizeButtonOptions(
                          style: TextStyle(color: Colors.white)),
                      fontFamily: QuillToolbarFontFamilyButtonOptions(
                          style: TextStyle(color: Colors.white))),
                  // Configuração dos botões (opcional)
                  showSuperscript: false,
                  showSubscript: false,
                  showQuote: false,
                  showClearFormat: false,
                  showCodeBlock: false,
                  showIndent: false,
                  showSearchButton: false,
                  showLink: false),
            ),
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
                        null),
                  ),
                ),
              ),
            ),
            if (imagemUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(imagemUrl!, height: 200),
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.purpleAccent),
                  onPressed: selecionarImagem,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
