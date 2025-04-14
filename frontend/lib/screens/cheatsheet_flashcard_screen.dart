import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../models/cheatsheet.dart';

class CheatSheetFlashcardScreen extends StatefulWidget {
  final String category;
  final List<CheatSheet> fiches;

  const CheatSheetFlashcardScreen({super.key, required this.category, required this.fiches});

  @override
  State<CheatSheetFlashcardScreen> createState() => _CheatSheetFlashcardScreenState();
}

class _CheatSheetFlashcardScreenState extends State<CheatSheetFlashcardScreen> {
  int currentIndex = 0;

  void nextCard() {
    setState(() {
      if (currentIndex < widget.fiches.length - 1) {
        currentIndex++;
      }
    });
  }

  void previousCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fiche = widget.fiches[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FlipCard(
              direction: FlipDirection.HORIZONTAL,
              front: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lightbulb, size: 40, color: Colors.amber),
                      const SizedBox(height: 12),
                      Text(
                        fiche.titre,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text("Appuie pour voir la réponse", style: TextStyle(fontStyle: FontStyle.italic))
                    ],
                  ),
                ),
              ),
              back: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_open, size: 40, color: Colors.green),
                      const SizedBox(height: 12),
                      Text(
                        fiche.contenu,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: "Précédent",
                onPressed: previousCard,
              ),
              Text("${currentIndex + 1} / ${widget.fiches.length}"),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                tooltip: "Suivant",
                onPressed: nextCard,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
