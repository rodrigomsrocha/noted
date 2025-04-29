import 'package:flutter/material.dart';
import 'package:noted/features/note/presentation/nota1.dart';
import 'package:noted/features/note/presentation/nota2.dart';
import 'package:noted/features/note/presentation/nota3.dart';
import 'package:noted/features/note/presentation/nota4.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = [
      {
        'title': 'Hábito Saudável',
        'preview':
            'Guia Básico para Criar um Hábito Saudável 💪🍏 Defina um objetivo claro...',
        'page': const NotaHabito(),
      },
      {
        'title': 'Checklist de Viagem',
        'preview':
            'Documentos Importantes 📄 • Passaporte ou RG • Cartões de crédito...',
        'page': const NotaViagem(),
      },
      {
        'title': 'Dicas de Mindfulness',
        'preview':
            'Respiração Consciente 🌬️ Reserve alguns minutos por dia para focar...',
        'page': const NotaMeditacao(),
      },
      {
        'title': 'Plano de Estudos',
        'preview':
            'Organização Semanal 📆 Monte um cronograma simples para seus estudos...',
        'page': NotaEstudos(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.note_alt_outlined, color: Colors.purple),
            SizedBox(width: 8),
            Text(
              'Noted!',
              style: TextStyle(color: Colors.purple),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search your notes',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[850],
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  dropdownColor: Colors.grey[850],
                  value: 'Estudos',
                  items: const [
                    DropdownMenuItem(value: 'Estudos', child: Text('Estudos')),
                    DropdownMenuItem(value: 'Pessoal', child: Text('Pessoal')),
                    DropdownMenuItem(
                        value: 'Trabalho', child: Text('Trabalho')),
                  ],
                  onChanged: (value) {},
                  style: const TextStyle(color: Colors.white),
                  underline: Container(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteCard(
                    title: note['title'] as String,
                    preview: note['preview'] as String,
                    page: note['page'] as Widget,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String preview;
  final Widget page;

  const NoteCard(
      {super.key,
      required this.title,
      required this.preview,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              preview,
              style: const TextStyle(
                color: Colors.white70,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
