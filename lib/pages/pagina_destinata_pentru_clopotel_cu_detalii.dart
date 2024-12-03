import 'package:cosmolot/models/file.article.dart';
import 'package:flutter/material.dart';

class PaginaDestinataPentruClopotelCuDetalii extends StatelessWidget {
  final Article article;

  const PaginaDestinataPentruClopotelCuDetalii(
      {super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff9B7EBD),
      appBar: AppBar(
        title: Text(article.title),
        backgroundColor: const Color(0xff9B7EBD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                article.imageUrl, // Display the article image
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'images/brat.webp', // Fallback image
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              article.title, // Article title
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Published at: ${article.publishedAt}', // Published date
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff7A1CAC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
