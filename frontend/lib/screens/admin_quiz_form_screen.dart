import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';  

class AdminQuizFormScreen extends StatefulWidget {
  const AdminQuizFormScreen({super.key});

  @override
  _AdminQuizFormScreenState createState() => _AdminQuizFormScreenState();
}

class _AdminQuizFormScreenState extends State<AdminQuizFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _question = '';
  String _correctAnswer = '';
  List<String> _choices = [];

  Future<void> createQuiz() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/admin/quizzes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'titre': _title,
        'question': _question,
        'choix': _choices,
        'bonne_reponse': _correctAnswer,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quiz créé avec succès")),
      );
      Navigator.pop(context);  // Go back after success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec de la création du quiz")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titre du quiz'),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Question'),
                onChanged: (value) {
                  setState(() {
                    _question = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une question';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Réponse correcte'),
                onChanged: (value) {
                  setState(() {
                    _correctAnswer = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la réponse correcte';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Choix (séparez par une virgule)'),
                onChanged: (value) {
                  setState(() {
                    _choices = value.split(',');
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer les choix';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createQuiz();
                    }
                  },
                  child: const Text('Créer le quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
