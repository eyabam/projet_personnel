import 'package:flutter/material.dart';
import '../models/cheatsheet.dart';

class CheatSheetDetailScreen extends StatelessWidget {
  final CheatSheet fiche;

  const CheatSheetDetailScreen({super.key, required this.fiche});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fiche.titre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            fiche.contenu,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
