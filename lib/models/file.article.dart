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

  get category => null;

  static Article fromJson(Map<String, dynamic> data) {
    return Article(
      title: data['title'],
      imageUrl: data['image_url'],
      newsSite: data['news_site'],
      summary: data['summary'],
      publishedAt: data['published_at'],
    );
  }

  static List<Article> fromJsonList(List<dynamic> data) {
    return data.map((articleData) => Article.fromJson(articleData)).toList();
  }
}
