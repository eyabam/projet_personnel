import 'dart:convert';

class Quiz {
  final int id;
  final String titre;
  final String question;
  final List<String> choix;
  final String bonneReponse;
  final String categorie;

  Quiz({
    required this.id,
    required this.titre,
    required this.question,
    required this.choix,
    required this.bonneReponse,
    required this.categorie,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    List<String> parsedChoix = [];

    // Gestion de différents formats de données pour "choix"
    if (json['choix'] is String) {
      try {
        final decoded = jsonDecode(json['choix']);
        parsedChoix = List<String>.from(decoded);
      } catch (e) {
        print(" Erreur lors du parsing JSON de choix : ${json['choix']}");
        parsedChoix = [];
      }
    } else if (json['choix'] is List) {
      parsedChoix = List<String>.from(json['choix']);
    }

    return Quiz(
      id: json['id'],
      titre: json['titre'],
      question: json['question'],
      choix: parsedChoix,
      bonneReponse: json['bonneReponse'] ?? json['bonne_reponse'] ?? '',
      categorie: json['categorie'] ?? 'Autre',
    );
  }
}
