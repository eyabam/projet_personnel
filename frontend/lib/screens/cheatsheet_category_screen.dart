// cheatsheet_category_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cheatsheet_flashcard_screen.dart';

class CheatSheetCategoryScreen extends StatefulWidget {
  const CheatSheetCategoryScreen({super.key});

  @override
  State<CheatSheetCategoryScreen> createState() => _CheatSheetCategoryScreenState();
}

class _CheatSheetCategoryScreenState extends State<CheatSheetCategoryScreen> {
  List<String> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/cheatsheets'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final distinctCategories = data.map((e) => e['categorie'] as String).toSet().toList();
        setState(() {
          categories = distinctCategories;
          isLoading = false;
        });
      } else {
        throw Exception("Erreur lors du chargement des catégories");
      }
    } catch (e) {
      print("Erreur: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catégories de fiches")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(category),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheatSheetFlashcardScreen(category: category),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
