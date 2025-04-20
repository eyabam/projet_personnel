// lib/services/admin_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  Future<void> createQuiz({
    required String titre,
    required String question,
    required List<String> choix,
    required String bonneReponse,
    required int categorieId, // <-- ici, int
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Utilisateur non authentifié');
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/admin/quizzes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'titre': titre,
        'question': question,
        'choix': choix,
        'bonne_reponse': bonneReponse,
        'categorie_id': categorieId, // <-- on envoie catégorie_id comme l'API attend
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erreur lors de la création du quiz');
    }
  }
}
