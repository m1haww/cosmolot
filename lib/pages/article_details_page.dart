import 'package:cosmolot/models/file.article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // Format the publication date to a more readable format
    final formattedDate = _formatDate(article.publishedAt);

    return Scaffold(
      backgroundColor: const Color(0xff9B7EBD),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.white,
        ),
        title: const Text(
          "Article Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff9B7EBD),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image Section
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    article.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'images/brat.webp', // Fallback image
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Article Title Section
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Article Published Date Section
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),

              // Article Summary Section
              Text(
                article.summary,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Article Source (News Site) Section
              Text(
                'Source: ${article.newsSite}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to format the published date into a readable format
  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year} at ${parsedDate.hour}:${parsedDate.minute}';
  }
}
