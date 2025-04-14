import 'package:flutter/material.dart';
import '../models/quiz.dart';
import 'quiz_detail_screen.dart';
import 'quiz_session_screen.dart';

class CategoryQuizScreen extends StatelessWidget {
  final String category;
  final List<Quiz> quizzes;

  const CategoryQuizScreen({
    super.key,
    required this.category,
    required this.quizzes,
  });

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'phishing':
        return Icons.phishing;
      case 'réseaux':
        return Icons.wifi;
      case 'cryptographie':
        return Icons.lock;
      case 'malware':
        return Icons.bug_report;
      case 'sécurité web':
        return Icons.security;
      case 'sécurité mobile':
        return Icons.phone_android;
      case 'cloud':
        return Icons.cloud;
      case 'sécurité physique':
        return Icons.badge;
      case 'sécurité des applications':
        return Icons.app_settings_alt;
      case 'gestion des accès':
        return Icons.verified_user;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(getCategoryIcon(category)),
            const SizedBox(width: 8),
            Expanded(child: Text("Catégorie : $category")),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: quizzes.isEmpty
          ? const Center(child: Text("Aucun quiz disponible pour cette catégorie."))
          : ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return ListTile(
                  title: Text(quiz.titre),
                  subtitle: Text(quiz.question),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizDetailScreen(quiz: quiz),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: quizzes.isNotEmpty
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.play_arrow),
              label: const Text("Démarrer"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizSessionScreen(quizzes: quizzes),
                  ),
                );
              },
            )
          : null,
    );
  }
}
