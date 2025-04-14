class CheatSheet {
  final int id;
  final String titre;
  final String contenu;
  final String categorie;

  CheatSheet({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.categorie,
  });

  factory CheatSheet.fromJson(Map<String, dynamic> json) {
    return CheatSheet(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      contenu: json['contenu'] ?? '',
      categorie: json['categorie'] ?? '',
    );
  }
}
