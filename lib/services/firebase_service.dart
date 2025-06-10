 import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _notasRef =
      FirebaseFirestore.instance.collection('notas');

  // Criar uma nova nota
  Future<void> salvarNota({
    required String titulo,
    required String texto,
    required String grupo,
    String? imagemUrl,
  }) async {
    final nota = {
      'titulo': titulo,
      'texto': texto,
      'grupo': grupo,
      'imagemUrl': imagemUrl,
      'dataCriacao': DateTime.now().toIso8601String(),
    };

    await _notasRef.add(nota);
  }

  // Atualizar uma nota existente
  Future<void> atualizarNota({
    required String id,
    required String titulo,
    required String texto,
    required String grupo,
    String? imagemUrl,
  }) async {
    final atualizacao = {
      'titulo': titulo,
      'texto': texto,
      'grupo': grupo,
      'imagemUrl': imagemUrl,
    };

    await _notasRef.doc(id).update(atualizacao);
  }

  // Buscar todas as notas
  Future<List<Map<String, dynamic>>> buscarTodasNotas() async {
    final snapshot =
        await _notasRef.orderBy('dataCriacao', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Buscar notas por grupo
  Future<List<Map<String, dynamic>>> buscarNotasPorGrupo(String grupo) async {
    final snapshot = await _notasRef
        .where('grupo', isEqualTo: grupo)
        .orderBy('dataCriacao', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Stream<List<Map<String, dynamic>>> streamNotasPorGrupo(String? grupo) {
    Query query = _notasRef.orderBy('dataCriacao', descending: true);

    if (grupo != null && grupo != 'Todos') {
      query = query.where('grupo', isEqualTo: grupo);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}
