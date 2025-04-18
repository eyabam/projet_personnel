// lib/models/score.dart

class Score {
  final int? id;
  final String titre;
  final String categorie;
  final int score;
  final int total;
  final DateTime createdAt;

  Score({
    this.id,
    required this.titre,
    required this.categorie,
    required this.score,
    required this.total,
    required this.createdAt,
  });

  // Calcule le pourcentage du score
  int get percentage => (score / total * 100).round();

  // Crée un objet Score à partir d'un JSON
  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      id: json['id'],
      titre: json['titre'] ?? 'Sans titre',
      categorie: json['categorie'] ?? 'Non catégorisé',
      score: json['score'] ?? 0,
      total: json['total'] ?? 10,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  // Convertit l'objet Score en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'categorie': categorie,
      'score': score,
      'total': total,
      'created_at': createdAt.toIso8601String(),
    };
  }
}