import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cheatsheet_flashcard_screen.dart';

import '../models/cheatsheet.dart';

class CheatSheetScreen extends StatefulWidget {
  const CheatSheetScreen({super.key});

  @override
  State<CheatSheetScreen> createState() => _CheatSheetScreenState();
}

class _CheatSheetScreenState extends State<CheatSheetScreen> {
  Map<String, List<CheatSheet>> grouped = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCheatsheets();
  }

  Future<void> fetchCheatsheets() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/cheatsheets'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final List<CheatSheet> cheatsheets = data.map((e) => CheatSheet.fromJson(e)).toList();

        grouped = {};
        for (var sheet in cheatsheets) {
          grouped.putIfAbsent(sheet.categorie, () => []).add(sheet);
        }

        setState(() => isLoading = false);
      } else {
        throw Exception("Erreur de chargement");
      }
    } catch (e) {
      print("⚠️ Erreur chargement cheatsheets : $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fiches de révision")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : grouped.isEmpty
              ? const Center(child: Text("Fiches à venir..."))
              : ListView(
                  children: grouped.entries.map((entry) {
                    final category = entry.key;
                    final fiches = entry.value;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheatSheetFlashcardScreen(
                                category: category,
                                fiches: fiches,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
