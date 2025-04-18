import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../bloc/score.dart';
import '../bloc/quiz_bloc.dart';
import '../models/score.dart';
import '../models/user.dart';
import '../main.dart';

import 'score_history_screen.dart';
import 'profile_screen.dart';
import 'cheatsheet_screen.dart';
import 'article_list_screen.dart';
import 'admin_quiz_form_screen.dart';
import 'package:frontend/screens/quiz_session_screen.dart' as session;
import 'package:frontend/screens/category_quiz_screen.dart' as category;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  bool isAdmin = false;
  TextEditingController searchController = TextEditingController();
  String username = "Utilisateur";
  
  final List<String> _categories = [
    'Tous',
    'Phishing',
    'Réseaux',
    'Cryptographie',
    'Malware',
    'Sécurité Web',
    'Sécurité Mobile',
    'Cloud',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUsername();
    checkIfAdmin();
    
    // Load data
    context.read<QuizBloc>().add(LoadQuizzes());
    context.read<ScoreBloc>().add(LoadScores());
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final user = User.fromToken(token);
      setState(() {
        username = user.username;
      });
    }
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenue, $username 👋"),
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: "Changer de thème",
            onPressed: () async {
              final newMode = themeNotifier.value == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
              themeNotifier.value = newMode;
              
              // Save preference
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isDark', newMode == ThemeMode.dark);
            },
          ),
          PopupMenuButton<String>(
            tooltip: "Menu",
            onSelected: (value) async {
              switch (value) {
                case 'cheatsheet':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheatSheetScreen()),
                  );
                  break;
                case 'articles':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ArticleListScreen()),
                  );
                  break;
                case 'profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                  break;
                case 'scores':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScoreHistoryScreen()),
                  );
                  break;
                case 'admin':
                  if (isAdmin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminQuizFormScreen()),
                    );
                  } else {
                    _showNotAdminMessage(context); // Custom message to non-admin users
                  }
                  break;
                case 'logout':
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'cheatsheet',
                  child: ListTile(
                    leading: Icon(Icons.menu_book),
                    title: Text('Fiches de révision'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'articles',
                  child: ListTile(
                    leading: Icon(Icons.article),
                    title: Text('Articles de sécurité'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Mon profil'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'scores',
                  child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Historique des scores'),
                  ),
                ),
                if (isAdmin)
                  const PopupMenuItem<String>(
                    value: 'admin',
                    child: ListTile(
                      leading: Icon(Icons.admin_panel_settings),
                      title: Text('Créer un quiz (admin)'),
                    ),
                  ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Déconnexion'),
                  ),
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            // Si l'utilisateur clique sur l'onglet Articles (index 2)
            if (index == 2) {
              // Empêcher le changement d'onglet
              _tabController.index = _tabController.previousIndex;
              
              // Naviguer vers ArticleListScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ArticleListScreen()),
              );
            }
          },
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: "Tableau de bord"),
            Tab(icon: Icon(Icons.quiz), text: "Quiz"),
            Tab(icon: Icon(Icons.article), text: "Articles"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Dashboard
          _buildDashboardTab(),
          
          // Tab 2: Quiz
          _buildQuizTab(),
          
          // Tab 3: Articles
          _buildArticlesTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    // Le FAB change selon l'onglet actif
    if (_tabController.index == 1) { // Quiz tab
      return BlocBuilder<QuizBloc, QuizState>(
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
              label: const Text("Quiz aléatoire"),
            );
          }
          return const SizedBox();
        },
      );
    } else if (_tabController.index == 2) { // Articles tab
      return FloatingActionButton(
        onPressed: () {
          // Action pour articles (peut-être filtrer ou rechercher)
        },
        child: const Icon(Icons.search),
      );
    }
    
    // Par défaut, pas de FAB pour l'onglet tableau de bord
    return const SizedBox();
  }

  // Onglet 1: Tableau de bord
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animation de bienvenue
          Center(
            child: Lottie.asset(
              'assets/animations/cyber_welcome.json',
              height: 160,
              repeat: true,
            ),
          ),
          const SizedBox(height: 16),
          
          // Section Statistiques
          _buildStatsSection(),
          
          const SizedBox(height: 24),
          
          // Section Activité Récente
          Text(
            'Activité Récente',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          // Activité récente (scores)
          _buildRecentActivity(),
          
          const SizedBox(height: 24),
          
          // Section Raccourcis Rapides
          Text(
            'Raccourcis Rapides',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          // Grille de raccourcis
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.3, // Augmenté pour plus d'espace vertical
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildShortcutCard(
                context,
                'Quiz',
                Icons.quiz,
                Colors.blue,
                () {
                  _tabController.animateTo(1); // Passer à l'onglet Quiz
                },
              ),
              _buildShortcutCard(
                context,
                'Articles',
                Icons.article,
                Colors.green,
                () {
                  // Ouvrir directement l'écran des articles
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ArticleListScreen()),
                  );
                },
              ),
              _buildShortcutCard(
                context,
                'Fiches',
                Icons.menu_book,
                Colors.orange,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheatSheetScreen()),
                  );
                },
              ),
              _buildShortcutCard(
                context,
                'Profil',
                Icons.person,
                Colors.purple,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
              _buildShortcutCard(
                context,
                'Scores',
                Icons.history,
                Colors.red,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScoreHistoryScreen()),
                  );
                },
              ),
              if (isAdmin)
                _buildShortcutCard(
                  context,
                  'Admin',
                  Icons.admin_panel_settings,
                  Colors.teal,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminQuizFormScreen(),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Fonction pour afficher un message d'erreur pour les utilisateurs non-admin
  void _showNotAdminMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accès refusé'),
        content: const Text("Vous devez être administrateur pour accéder à cette section."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Onglet 2: Quiz
  Widget _buildQuizTab() {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
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
      },
    );
  }

  // Onglet 3: Articles
  Widget _buildArticlesTab() {
    return const SizedBox.shrink();
  }

  // Section des statistiques
  Widget _buildStatsSection() {
    return BlocBuilder<ScoreBloc, ScoreState>(
      builder: (context, state) {
        int quizCount = 0;
        int averageScore = 0;
        
        if (state is ScoresLoaded) {
          final scores = state.scores;
          quizCount = scores.length;
          
          if (quizCount > 0) {
            int totalPercentage = scores.fold(0, (sum, score) => sum + score.percentage);
            averageScore = totalPercentage ~/ quizCount;
          }
        }
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vos Statistiques',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '$quizCount',
                        'Quiz Complétés',
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '$averageScore%',
                        'Score Moyen',
                        Icons.trending_up,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '3',
                        'Jours de Streak',
                        Icons.local_fire_department,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget pour afficher l'activité récente
  Widget _buildRecentActivity() {
    return BlocBuilder<ScoreBloc, ScoreState>(
      builder: (context, state) {
        if (state is ScoreLoading) {
          return const Center(child: CircularProgressIndicator());
        } 
        
        if (state is ScoresLoaded) {
          final scores = state.scores;
          if (scores.isNotEmpty) {
            final recentScores = scores.take(3).toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentScores.length,
              itemBuilder: (context, index) {
                final score = recentScores[index];
                
                // Formater la date
                final formattedDate = DateFormat('dd/MM/yyyy').format(score.createdAt);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getScoreColor(score.percentage).withOpacity(0.2),
                      child: Text(
                        '${score.percentage}%',
                        style: TextStyle(
                          color: _getScoreColor(score.percentage),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      score.categorie,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(score.percentage),
                      ),
                    ),
                    subtitle: Text('Score : ${score.score}/${score.total} • Complété le $formattedDate'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Afficher les détails du score
                      _showScoreDetails(context, score);
                    },
                  ),
                );
              },
            );
          }
        }
        
        // Pas de scores ou état initial
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48.0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Aucune activité récente',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Complétez quelques quiz pour voir votre activité ici',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget pour une carte de statistique
  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour une carte de raccourci
  Widget _buildShortcutCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajout de cette ligne pour réduire la taille
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8), // Réduire la taille du padding
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24, // Réduire légèrement la taille de l'icône
                ),
              ),
              const SizedBox(height: 4), // Réduire l'espace
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // Réduire la taille du texte
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Afficher les détails d'un score
  void _showScoreDetails(BuildContext context, Score score) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        score.titre,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                
                // Score circle
                Center(
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getScoreColor(score.percentage).withOpacity(0.1),
                      border: Border.all(
                        color: _getScoreColor(score.percentage),
                        width: 4.0,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${score.percentage}%',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(score.percentage),
                            ),
                          ),
                          Text(
                            '${score.score}/${score.total}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24.0),
                
                // Details
                _buildDetailRow('Catégorie', score.categorie),
                const Divider(),
                _buildDetailRow(
                  'Date', 
                  DateFormat('dd MMMM yyyy à HH:mm').format(score.createdAt)
                ),
                const Divider(),
                _buildDetailRow(
                  'Performance', 
                  _getPerformanceText(score.percentage)
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getPerformanceText(int percentage) {
    if (percentage >= 90) {
      return 'Excellent';
    } else if (percentage >= 75) {
      return 'Très bien';
    } else if (percentage >= 60) {
      return 'Bien';
    } else if (percentage >= 50) {
      return 'Moyen';
    } else {
      return 'À améliorer';
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
