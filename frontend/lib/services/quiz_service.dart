import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz.dart';
import '../models/score.dart';

class QuizService {
  final String baseUrl = 'http://localhost:3000/api';

  Future<List<Quiz>> fetchQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token JWT non trouvé');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/quizzes'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((quiz) => Quiz.fromJson(quiz)).toList();
    } else {
      throw Exception('Erreur lors du chargement des quizzes');
    }
  }

  Future<List<Score>> fetchScores() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token JWT non trouvé');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/scores'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> scoresData = responseBody['scores'];
      return scoresData.map((score) => Score.fromJson(score)).toList();
    } else {
      throw Exception('Erreur lors du chargement des scores');
    }
  }
}