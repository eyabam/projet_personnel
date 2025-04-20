import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz.dart';
import '../models/score.dart';

class QuizService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Quiz>> fetchQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token manquant. Veuillez vous reconnecter.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/quizzes'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Quiz.fromJson(item)).toList(); // 🔥 ici on transforme en objets Quiz
    } else {
      throw Exception('Erreur lors de la récupération des quizzes');
    }
  }

  Future<List<Score>> fetchScores() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token manquant. Veuillez vous reconnecter.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/scores'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Score.fromJson(item)).toList(); // 🔥 ici on transforme en objets Score
    } else {
      throw Exception('Erreur lors de la récupération des scores');
    }
  }
}
