import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cosmolot/models/file.article.dart'; // Import your article model
import 'package:cosmolot/pages/detail_news_page.dart'; // For detail navigation

class SearchIconcaAparte extends StatefulWidget {
  final List<Article> articles; // List of articles to search from

  const SearchIconcaAparte({super.key, required this.articles});

  @override
  _SearchIconcaAparteState createState() => _SearchIconcaAparteState();
}

class _SearchIconcaAparteState extends State<SearchIconcaAparte> {
  String searchQuery = '';
  List<Article> filteredArticles = [];

  @override
  void initState() {
    super.initState();
    filteredArticles = widget.articles;
  }

  void _filterArticles(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredArticles = widget.articles;
      } else {
        filteredArticles = widget.articles.where((article) {
          return article.title.toLowerCase().contains(query.toLowerCase()) ||
              article.newsSite.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<bool> checkImageUrl(String url) async {
    try {
      final response = await HttpClient()
          .headUrl(Uri.parse(url))
          .then((request) => request.close());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff9B7EBD),
      appBar: AppBar(
        backgroundColor: const Color(0xff9B7EBD),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        elevation: 0,
        title: const Text(
          "Discover",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (query) {
                          _filterArticles(query);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF0F0F0),
                          hintText: 'Search articles...',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon: const Icon(Icons.search,
                              color: Colors.blueAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Set the number of columns
                  crossAxisSpacing: 10, // Space between columns
                  mainAxisSpacing: 10, // Space between rows
                  childAspectRatio: 1, // Adjust aspect ratio for grid items
                ),
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailNewsPage(article: article),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FutureBuilder<bool>(
                                future: checkImageUrl(article.imageUrl),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError ||
                                      !(snapshot.data ?? false)) {
                                    return Image.asset(
                                      'images/brat.webp',
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return Image.network(
                                      article.imageUrl,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              )),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xD9EBD3F8),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            bottom: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  article.publishedAt.substring(0, 10),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
