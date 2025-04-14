class Article {
  final String title;
  final String summary;
  final String content;
  final String url;

  Article({
    required this.title,
    required this.summary,
    required this.content,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '', 
      summary: json['summary'] ?? '', 
      content: json['content'] ?? '',
      url: json['url'] ?? '', 
    );
  }
}
