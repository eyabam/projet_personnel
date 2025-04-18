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
      appBar: AppBar(
        backgroundColor: Colors.blue, // Custom background color
        title: const Text(
          "Fiches de révision",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Chargement des fiches..."),
                ],
              ),
            )
          : grouped.isEmpty
              ? const Center(child: Text("Aucune fiche disponible pour le moment.", style: TextStyle(fontSize: 16, color: Colors.grey)))
              : ListView(
                  children: grouped.entries.map((entry) {
                    final category = entry.key;
                    final fiches = entry.value;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 4, // Added shadow for depth
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          category,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
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
