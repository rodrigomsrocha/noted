import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
class FirebaseService {
  final CollectionReference _notasRef =
      FirebaseFirestore.instance.collection('notas');

  Future<String?> uploadImagem(String base64Image) async {
    final apiKey = dotenv.env['IMGBB_API_KEY'] ?? '';
    final url = Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');

    final response = await http.post(url, body: {
      'image': base64Image,
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']['url'];
    } else {
      print('Erro ao enviar imagem: ${response.body}');
      return null;
    }
  }

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

  Future<void> deletarNota(String id) async {
    await _notasRef.doc(id).delete();
  }
}
