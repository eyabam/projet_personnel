import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score.dart';

class ScoreService {
  final String baseUrl = "http://localhost:3000"; // change si besoin

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveScore({
    required String titre,
    required String categorie,
    required int score,
    required int total,
  }) async {
    final token = await getToken();
    print(" TOKEN utilisé pour POST /scores : $token");
    if (token == null) throw Exception("Token manquant");

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

    if (response.statusCode != 201) {
      throw Exception("Erreur enregistrement : ${response.body}");
    }
  }

  Future<List<Score>> getUserScores() async {
    final token = await getToken();
    print(" TOKEN utilisé pour GET /scores : $token");
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('$baseUrl/api/scores'),
      headers: {
        'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Score.fromJson(e)).toList();
    } else {
      throw Exception("Erreur chargement scores");
    }
  }
}
