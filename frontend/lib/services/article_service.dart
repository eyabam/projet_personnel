import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/article_model.dart'; // Import Article model

class ArticleService {
  // Use your actual API URL here
  final String apiUrl = "https://newsapi.org/v2/everything?q=cybersecurity&apiKey=9e7aaf698ca04b7ca1ace8ed1d912e97";

  Future<List<Article>> fetchArticles() async {
  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articles"];
      // Make sure you handle any potential null values in the data
      return data
          .map((article) => Article.fromJson(article ?? {})) // handle null article
          .toList();
    } else {
      throw Exception('Failed to load articles');
    }
  } catch (e) {
    throw Exception('Failed to load articles: $e');
  }
}
}

