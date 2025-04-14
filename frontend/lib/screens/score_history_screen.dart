import 'package:flutter/material.dart';
import '../models/score.dart';
import '../services/score_service.dart';

class ScoreHistoryScreen extends StatefulWidget {
  const ScoreHistoryScreen({super.key});

  @override
  State<ScoreHistoryScreen> createState() => _ScoreHistoryScreenState();
}

class _ScoreHistoryScreenState extends State<ScoreHistoryScreen> {
  final ScoreService service = ScoreService();

  List<Score> allScores = [];
  String? selectedCategorie;

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    try {
      final scores = await service.getUserScores();
      setState(() {
        allScores = scores;
      });
    } catch (e) {
      debugPrint("Erreur lors de la récupération des scores : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategorie == null
        ? allScores
        : allScores.where((s) => s.categorie == selectedCategorie).toList();

    final categories = allScores.map((s) => s.categorie).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Historique des scores")),
      body: Column(
        children: [
          if (categories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: selectedCategorie,
                isExpanded: true,
                hint: const Text("Filtrer par catégorie"),
                items: [
                  const DropdownMenuItem(value: null, child: Text("Toutes les catégories")),
                  ...categories.map((c) =>
                      DropdownMenuItem(value: c, child: Text(c))),
                ],
                onChanged: (value) {
                  setState(() => selectedCategorie = value);
                },
              ),
            ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("Aucun score pour cette catégorie"))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final score = filtered[index];
                      return ListTile(
                        title: Text("${score.titre} (${score.categorie})"),
                        subtitle: Text("Score : ${score.score}/${score.total}"),
                        trailing: Text(
                          score.date.toString().split(' ')[0],
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
