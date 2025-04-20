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
        print("Structure de la réponse: ${response.body}");
        
        final dynamic responseData = jsonDecode(response.body);
        print("Type de réponse: ${responseData.runtimeType}");
        
        List<dynamic> scoresData;
        
        if (responseData is Map<String, dynamic>) {
          // Si la réponse est un objet avec une clé 'scores'
          if (responseData.containsKey('scores')) {
            var scores = responseData['scores'];
            if (scores is List) {
              scoresData = scores;
            } else {
              print("Format inattendu pour 'scores': ${scores.runtimeType}");
              throw Exception("Format de 'scores' inattendu");
            }
          } else {
            // Essayons de trouver une clé qui contient une liste
            var listKey = responseData.keys.firstWhere(
              (key) => responseData[key] is List,
              orElse: () => '',
            );
            
            if (listKey.isNotEmpty) {
              scoresData = responseData[listKey] as List<dynamic>;
              print("Utilisation de la clé '$listKey' comme source de scores");
            } else {
              print("Aucune liste trouvée dans la réponse: $responseData");
              throw Exception('Format de réponse inattendu');
            }
          }
        } else if (responseData is List) {
          // Si la réponse est directement une liste
          scoresData = responseData;
        } else {
          print("Type de données inattendu: ${responseData.runtimeType}");
          throw Exception('Type de données inattendu');
        }
        
        print("Type de scoresData: ${scoresData.runtimeType}");
        print("Premier élément: ${scoresData.isNotEmpty ? scoresData.first : 'aucun élément'}");
        
        final scores = scoresData.map((e) => Score.fromJson(e as Map<String, dynamic>)).toList();
        print("Nombre de scores récupérés: ${scores.length}");
        
        return scores;
      } else {
        print("Erreur API: ${response.body}");
        throw Exception('Failed to load scores: ${response.statusCode}');
      }
    } catch (e) {
      print("⚠️ Erreur chargement scores : $e");
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