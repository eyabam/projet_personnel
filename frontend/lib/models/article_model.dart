class Article {
  final String title;
  final String summary;
  final String content;
  final String url;
  final String? author;
  final String? imageUrl;
  final DateTime? publishedDate; 
  final List<String>? tags;

  Article({
    required this.title,
    required this.summary,
    required this.content,
    required this.url,
    this.author,
    this.imageUrl,
    this.publishedDate,
    this.tags,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      author: json['author'],
      imageUrl: json['urlToImage'],
      publishedDate: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt']) 
          : null,
      tags: json['tags']?.cast<String>(),
    );
  }
}
