class Article {
  final String title;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;

  Article({
    required this.title,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  // Method to convert a single article from JSON
  static Article fromJson(Map<String, dynamic> data) {
    return Article(
      title: data['title'],
      imageUrl: data['image_url'],
      newsSite: data['news_site'],
      summary: data['summary'],
      publishedAt: data['published_at'],
    );
  }

  // Method to convert a list of articles from JSON
  static List<Article> fromJsonList(List<dynamic> data) {
    return data.map((articleData) => Article.fromJson(articleData)).toList();
  }
}
