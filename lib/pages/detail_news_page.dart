import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cosmolot/models/file.article.dart';

class DetailNewsPage extends StatelessWidget {
  final Article article;

  const DetailNewsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff9B7EBD), // Darker background color
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.white,
        ),
        backgroundColor: const Color(0xff9B7EBD), // Slightly darker purple
        title: const Text(
          "News",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 3,
                        offset: const Offset(4, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'images/brat.webp',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Article Details Section
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                article.publishedAt.substring(0, 10),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                article.summary,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
