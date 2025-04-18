import 'package:flutter/material.dart';
import '../models/cheatsheet.dart';

class CheatSheetDetailScreen extends StatelessWidget {
  final CheatSheet fiche;

  const CheatSheetDetailScreen({super.key, required this.fiche});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Custom background color
        title: Text(
          fiche.titre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4, // Shadow for the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(
                fiche.contenu, // Making text selectable for better usability
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6, // Improved line spacing for readability
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
