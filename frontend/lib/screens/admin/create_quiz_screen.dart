import 'package:flutter/material.dart';
import '../../services/admin_service.dart'; // Ton service qui envoie la requête POST

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _questionController = TextEditingController();
  final _choixController = TextEditingController();
  final _bonneReponseController = TextEditingController();
  String? _selectedCategory;

  // Liste affichée dans le Dropdown
  final List<String> categories = [
    'Phishing',
    'Réseaux',
    'Cryptographie',
    'Malware',
    'Sécurité Web',
    'Sécurité Mobile',
    'Cloud',
  ];

  // Correspondance entre le texte et l'id réel
  final Map<String, int> categoryToId = {
    'Phishing': 1,
    'Réseaux': 2,
    'Cryptographie': 3,
    'Malware': 4,
    'Sécurité Web': 5,
    'Sécurité Mobile': 6,
    'Cloud': 7,
  };

  @override
  void dispose() {
    _titreController.dispose();
    _questionController.dispose();
    _choixController.dispose();
    _bonneReponseController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await AdminService().createQuiz(
        titre: _titreController.text,
        question: _questionController.text,
        choix: _choixController.text.split(',').map((e) => e.trim()).toList(), // Nettoie les espaces
        bonneReponse: _bonneReponseController.text,
        categorieId: categoryToId[_selectedCategory!]!, // <-- On envoie l'ID ici
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz créé avec succès')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(labelText: 'Titre du quiz'),
                validator: (value) => value!.isEmpty ? 'Obligatoire' : null,
              ),
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (value) => value!.isEmpty ? 'Obligatoire' : null,
              ),
              TextFormField(
                controller: _choixController,
                decoration: const InputDecoration(labelText: 'Choix (séparés par virgule)'),
                validator: (value) => value!.isEmpty ? 'Obligatoire' : null,
              ),
              TextFormField(
                controller: _bonneReponseController,
                decoration: const InputDecoration(labelText: 'Bonne réponse'),
                validator: (value) => value!.isEmpty ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Catégorie'),
                validator: (value) => value == null ? 'Choisissez une catégorie' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Créer le quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
