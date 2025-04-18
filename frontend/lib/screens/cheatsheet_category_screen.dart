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
      appBar: AppBar(
        backgroundColor: Colors.blue, 
        title: const Text(
          "Catégories de fiches",
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
                  Text("Chargement des catégories..."),
                ],
              ),
            )
          : categories.isEmpty
              ? const Center(
                  child: Text(
                    "Aucune catégorie disponible",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 4, // Shadow for depth
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16), // Add padding inside each ListTile
                        title: Text(
                          category,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
