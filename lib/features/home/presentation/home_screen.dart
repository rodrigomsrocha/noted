import 'package:flutter/material.dart';
import 'package:noted/services/firebase_service.dart';
import 'package:noted/widgets/ai_chat_widget.dart';
import 'criar_nota.dart';
import 'editar_nota.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firebaseService = FirebaseService();
  List<Map<String, dynamic>> _notas = [];
  String _grupoSelecionado = 'Todos';
  final List<String> _grupos = [
    'Todos',
    'Pessoal',
    'Trabalho',
    'Estudos',
    'Outros'
  ];
  bool _carregandoNotas = false;
  @override
  void initState() {
    super.initState();
    carregarNotas();
  }

  Future<void> carregarNotas() async {
    final notas = await firebaseService.buscarTodasNotas();
    setState(() {
      _notas = notas;
    });
  }

  Future<void> filtrarPorGrupo(String grupo) async {
    setState(() {
      _carregandoNotas = true;
      _grupoSelecionado = grupo;
    });

    // Aguarda o stream atualizar automaticamente
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _carregandoNotas = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B14),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.purpleAccent),
          onPressed: () {},
        ),
        title: const Text(
          'Minhas Notas',
          style: TextStyle(
              color: Colors.purpleAccent, fontWeight: FontWeight.bold),
        ),
        actions: [
          DropdownButton<String>(
            dropdownColor: Colors.grey[900],
            value: _grupoSelecionado,
            hint: const Text('Grupo', style: TextStyle(color: Colors.white)),
            items: _grupos.map((String grupo) {
              return DropdownMenuItem<String>(
                value: grupo,
                child: Text(grupo, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (String? novoGrupo) {
              if (novoGrupo != null) {
                filtrarPorGrupo(novoGrupo);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.purpleAccent),
            onPressed: carregarNotas,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_carregandoNotas)
            const LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              color: Colors.purpleAccent,
            ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: firebaseService.streamNotasPorGrupo(_grupoSelecionado),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma nota encontrada.',
                        style: TextStyle(color: Colors.white70)),
                  );
                }

                final notas = snapshot.data!;
                return ListView.builder(
                  itemCount: notas.length,
                  itemBuilder: (context, index) {
                    final nota = notas[index];
                    return Card(
                      color: Colors.grey[850],
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(nota['titulo'],
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(nota['grupo'],
                            style: const TextStyle(color: Colors.white54)),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NotaHabito(nota: nota)),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar Exclusão'),
                                content: const Text(
                                    'Tem certeza que deseja excluir esta nota?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Excluir'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await firebaseService.deletarNota(nota['id']);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: [
          AiChat(),
          FloatingActionButton(
            backgroundColor: Colors.purpleAccent,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CriarNota()),
              );
              carregarNotas(); // Recarrega as notas após criar uma nova
            },
          ),
        ],
      ),
    );
  }
}
