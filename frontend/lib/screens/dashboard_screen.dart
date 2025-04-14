import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/quiz_bloc.dart';
import '../models/score.dart';
import '../models/user.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final user = User.fromToken(token);
      setState(() {
        userId = user.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tableau de bord")),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading || userId == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuizLoaded) {
            final List<Score> scores = state.scores.where((s) => s.userId == userId).toList();

            final totalQuizzesDone = scores.length;
            final categoriesPlayed = scores.map((s) => s.categorie).toSet().length;

            final hasBadge5Quizzes = totalQuizzesDone >= 5;
            final hasBadge3Categories = categoriesPlayed >= 3;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mes badges 🌟", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  BadgeTile(title: "5 quiz terminés", unlocked: hasBadge5Quizzes),
                  BadgeTile(title: "3 catégories différentes jouées", unlocked: hasBadge3Categories),
                  const SizedBox(height: 32),
                  const Text("Résumé", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Text("Total de quiz joués : $totalQuizzesDone"),
                  Text("Catégories différentes : $categoriesPlayed"),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Erreur de chargement du tableau de bord."));
          }
        },
      ),
    );
  }
}

class BadgeTile extends StatelessWidget {
  final String title;
  final bool unlocked;

  const BadgeTile({super.key, required this.title, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: unlocked ? Colors.green[100] : Colors.grey[200],
      child: ListTile(
        leading: Icon(
          unlocked ? Icons.emoji_events : Icons.lock,
          color: unlocked ? Colors.amber : Colors.grey,
        ),
        title: Text(title),
        subtitle: Text(unlocked ? "Débloqué !" : "Non débloqué"),
      ),
    );
  }
}
