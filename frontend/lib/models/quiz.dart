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

    // Ensure 'choix' is a valid format before trying to decode or convert
    if (json['choix'] is String) {
      try {
        final decoded = jsonDecode(json['choix']);
        parsedChoix = List<String>.from(decoded);
      } catch (e) {
        print("Erreur lors du parsing JSON de choix : ${json['choix']}");
        parsedChoix = []; // fallback to an empty list
      }
    } else if (json['choix'] is List) {
      parsedChoix = List<String>.from(json['choix']);
    }

    // Extract values from JSON with fallback defaults
    return Quiz(
      id: json['id'] ?? 0,  // Fallback to 0 if id is missing
      titre: json['titre'] ?? 'Titre non défini',  // Provide a default title if missing
      question: json['question'] ?? 'Question non définie',  // Provide a default question if missing
      choix: parsedChoix,
      bonneReponse: json['bonneReponse'] ?? json['bonne_reponse'] ?? 'Aucune réponse', // Fallback to a default answer
      categorie: json['categorie'] ?? 'Autre',  // Default to 'Autre' if no category is found
    );
  }
}
