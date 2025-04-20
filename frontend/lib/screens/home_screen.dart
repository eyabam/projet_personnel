import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

import '../bloc/quiz_bloc.dart';
import '../models/user.dart';
import 'score_history_screen.dart';

import 'profile_screen.dart';
import 'dashboard_screen.dart';
import 'cheatsheet_screen.dart';
import 'package:frontend/screens/quiz_session_screen.dart' as session;
import 'package:frontend/screens/category_quiz_screen.dart' as category;
import 'admin/create_quiz_screen.dart';

import 'article_list_screen.dart'; 

import '../main.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAdmin = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkIfAdmin();
    context.read<QuizBloc>().add(LoadQuizzes());
  }

  Future<void> checkIfAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final user = User.fromToken(token);
      setState(() {
        isAdmin = user.isAdmin;
      });
    }
  }

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
        title: Text("Bienvenue, ${widget.username} 👋"),
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            tooltip: "Changer de thème",
            onPressed: () async {
              final newMode = themeNotifier.value == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
              themeNotifier.value = newMode;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isDark', newMode == ThemeMode.dark);
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: "Fiches de révision",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheatSheetScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.article),
            tooltip: "Articles de sécurité", 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ArticleListScreen()), 
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: "Voir le tableau de bord",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<QuizBloc>(),
                    child: const DashboardScreen(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Mon profil",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "Historique des scores",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ScoreHistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Déconnexion",
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: "Créer un quiz (admin)",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateQuizScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: BlocBuilder<QuizBloc, QuizState>(builder: (context, state) {
        if (state is QuizLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is QuizLoaded) {
          final allCategories = state.quizzes.map((q) => q.categorie).toSet().toList()..sort();

          final filteredByKeyword = state.quizzes.where((q) {
            final keyword = searchController.text.toLowerCase();
            return q.titre.toLowerCase().contains(keyword) ||
                q.question.toLowerCase().contains(keyword);
          }).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                Lottie.asset(
                  'assets/animations/cyber_welcome.json',
                  height: 160,
                  repeat: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Rechercher un quiz',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'Quiz : ${state.quizzes.length}  |  Catégories : ${allCategories.length}',
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
                ...allCategories.map((cat) {
                  final quizzesForCategory = filteredByKeyword
                      .where((q) => q.categorie == cat)
                      .toList();

                  if (quizzesForCategory.isEmpty) return const SizedBox();

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: Icon(getCategoryIcon(cat)),
                      title: Text(
                        '$cat (${quizzesForCategory.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => category.CategoryQuizScreen(
                              category: cat,
                              quizzes: quizzesForCategory,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        } else if (state is QuizError) {
          return Center(child: Text("Erreur: ${state.message}"));
        } else {
          return const Center(child: Text("Aucun quiz disponible."));
        }
      }),
      floatingActionButton: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoaded && state.quizzes.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => session.QuizSessionScreen(quizzes: state.quizzes),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Tous les quizzes"),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
