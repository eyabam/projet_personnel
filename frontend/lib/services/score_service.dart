import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score.dart';

class ScoreService {
  final String baseUrl = "http://localhost:3000";

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Score>> getUserScores() async {
    final token = await getToken();
    
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/scores'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Récupération des scores - Statut: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> scoresData = responseBody['scores'];
        
        final scores = scoresData.map((e) => Score.fromJson(e)).toList();
        print("Nombre de scores récupérés: ${scores.length}");
        
        return scores;
      } else {
        print("Erreur API: ${response.body}");
        throw Exception('Failed to load scores: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception lors de la récupération des scores: $e");
      throw Exception('Network error: $e');
    }
  }

  Future<void> saveScore({
    required String titre,
    required String categorie,
    required int score,
    required int total,
  }) async {
    final token = await getToken();
    
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      print("Tentative de sauvegarde du score: $titre, $categorie, $score/$total");
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/scores'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'titre': titre,
          'categorie': categorie,
          'score': score,
          'total': total,
        }),
      );

      print("Sauvegarde du score - Statut: ${response.statusCode}");
      
      if (response.statusCode != 201) {
        print("Erreur API: ${response.body}");
        throw Exception('Failed to save score: ${response.statusCode}');
      } else {
        print("Score sauvegardé avec succès");
      }
    } catch (e) {
      print("Exception lors de la sauvegarde du score: $e");
      throw Exception('Network error: $e');
    }
  }
}