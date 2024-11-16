import 'dart:convert';
import 'package:cosmolot/models/file.article.dart';
import 'package:http/http.dart' as http;

List<Article> articles = [];
Future<void> fetchArticles() async {
  final url = Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/');

  try {
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);

      // Extract the 'results' part of the JSON response and convert it to a list of Article objects
      articles = Article.fromJsonList(data['results']);

      // Print out the titles of the articles (or handle them as needed)
      for (var article in articles) {
        print(article.title);
      }

      // Handle the articles as needed, e.g., passing them to your UI
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}
