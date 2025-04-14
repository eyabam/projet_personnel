import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/article_service.dart';
import 'article_detail_screen.dart'; // Import the ArticleDetailScreen

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  late Future<List<Article>> articles;

  @override
  void initState() {
    super.initState();
    articles = ArticleService().fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Articles")),
      body: FutureBuilder<List<Article>>(
        future: articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement des articles"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun article disponible"));
          } else {
            final articlesList = snapshot.data!;

            return ListView.builder(
              itemCount: articlesList.length,
              itemBuilder: (context, index) {
                final article = articlesList[index];
                return ListTile(
                  title: Text(article.title),
                  subtitle: Text(article.summary),
                  onTap: () {
                    // Navigate to ArticleDetailScreen when an article is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
