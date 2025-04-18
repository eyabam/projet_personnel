import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article_model.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  
  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);
  
  // Méthode pour ouvrir l'URL dans le navigateur
  Future<void> _launchURL() async {
    final Uri url = Uri.parse(article.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossible d\'ouvrir l\'URL: ${article.url}');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité de partage à implémenter')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Article sauvegardé')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image d'en-tête (conditionnelle)
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(article.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            // Contenu principal
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre de l'article
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Métadonnées (auteur, date)
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        article.author ?? 'Auteur inconnu',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        article.publishedDate != null 
                            ? _formatDate(article.publishedDate!) 
                            : 'Date inconnue',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  
                  const Divider(height: 32),
                  
                  // Résumé de l'article
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      article.summary,
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Contenu principal
                  Text(
                    article.content,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Tags (si disponibles)
                  if (article.tags != null && article.tags!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tags',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: article.tags!.map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          )).toList(),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Bouton "Lire l'article complet"
                  InkWell(
                    onTap: _launchURL,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Lire l'article complet",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchURL,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.open_in_new),
        tooltip: "Ouvrir l'URL",
      ),
    );
  }
  
  // Méthode pour formater la date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}