// utils/api.dart
import 'dart:convert';
import 'package:cosmolot/models/file_article_rocket.dart';
import 'package:http/http.dart' as http;

List<RocketArticle> jopa = [];

Future<void> fetchCores() async {
  final url = Uri.parse('https://api.spacexdata.com/v3/cores');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    jopa = RocketArticle.fromJsonList(
        data); // Convert the fetched data into Article objects
  } else {
    print('Failed to fetch data: ${response.statusCode}');
  }
}
