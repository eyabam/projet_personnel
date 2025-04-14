class Score {
  final int userId;
  final String titre;
  final String categorie;
  final int score;
  final int total;
  final DateTime date;

  Score({
    required this.userId,
    required this.titre,
    required this.categorie,
    required this.score,
    required this.total,
    required this.date,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      userId: json['user_id'] ?? 0,
      titre: json['titre'] ?? '',
      categorie: json['categorie'] ?? '',
      score: json['score'] ?? 0,
      total: json['total'] ?? 0,
      date: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
    );
  }
}
