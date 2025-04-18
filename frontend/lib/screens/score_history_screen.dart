import 'dart:async';
import 'package:flutter/material.dart';
import '../models/score.dart';
import '../services/score_service.dart';
import 'package:intl/intl.dart';

class ScoreHistoryScreen extends StatefulWidget {
  const ScoreHistoryScreen({super.key});

  @override
  State<ScoreHistoryScreen> createState() => _ScoreHistoryScreenState();
}

class _ScoreHistoryScreenState extends State<ScoreHistoryScreen> {
  final ScoreService service = ScoreService();

  List<Score> allScores = [];
  String? selectedCategorie;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final scores = await service.getUserScores();
      
      setState(() {
        allScores = scores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur lors de la récupération des scores : $e";
        _isLoading = false;
      });
      debugPrint(_errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only filter if not loading and no error
    final filtered = _isLoading || _errorMessage.isNotEmpty
        ? []
        : (selectedCategorie == null
            ? allScores
            : allScores.where((s) => s.categorie == selectedCategorie).toList());

    final categories = allScores.map((s) => s.categorie).toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historique des scores", 
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchScores,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchScores,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (categories.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue, width: 1),
                          ),
                          child: DropdownButton<String>(
                            value: selectedCategorie,
                            isExpanded: true,
                            hint: const Text("Toutes les catégories"),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            items: [
                              const DropdownMenuItem(
                                  value: null, 
                                  child: Text("Toutes les catégories")
                              ),
                              ...categories.map((c) => DropdownMenuItem(
                                  value: c, child: Text(c))),
                            ],
                            onChanged: (value) {
                              setState(() => selectedCategorie = value);
                            },
                          ),
                        ),
                      ),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(
                              child: Text(
                                "Aucun score pour cette catégorie",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final score = filtered[index];
                                
                                // Formater la date
                                final formattedDate = DateFormat('dd/MM/yyyy').format(score.createdAt);
                                
                                return Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    title: Text(
                                      score.categorie,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Score : ${score.score}/${score.total}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    trailing: Text(
                                      formattedDate,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
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