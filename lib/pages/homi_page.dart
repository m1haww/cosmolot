import 'package:cosmolot/models/file.article.dart';
import 'package:cosmolot/models/icon_clopotel.dart';
import 'package:cosmolot/pages/detail_news_page.dart';
import 'package:cosmolot/pages/view_all.dart';
import 'package:flutter/material.dart';
import 'package:cosmolot/utils/utils.api.dart';

class HomiPage extends StatefulWidget {
  @override
  _HomiPageState createState() => _HomiPageState();
}

class _HomiPageState extends State<HomiPage> {
  final breakingNewsArticles = articles.take(3).toList();
  final recommendationArticles = articles.skip(3).toList();
  bool isExpanded = false;
  bool isSearching = false;
  String searchQuery = '';

  List<Article> filteredBreakingNews = [];
  List<Article> filteredRecommendations = [];

  @override
  void initState() {
    super.initState();
    filteredBreakingNews = breakingNewsArticles;
    filteredRecommendations = recommendationArticles;
  }

  void _filterArticles(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredBreakingNews = breakingNewsArticles;
        filteredRecommendations = recommendationArticles;
      } else {
        filteredBreakingNews = breakingNewsArticles.where((article) {
          return article.title.toLowerCase().contains(query.toLowerCase()) ||
              article.newsSite.toLowerCase().contains(query.toLowerCase());
        }).toList();

        filteredRecommendations = recommendationArticles.where((article) {
          return article.title.toLowerCase().contains(query.toLowerCase()) ||
              article.newsSite.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff9B7EBD),
      appBar: AppBar(
        backgroundColor: const Color(0xff9B7EBD),
        centerTitle: true,
        title: isSearching
            ? Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: const Color(0xff2E073F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    autofocus: true,
                    onChanged: (query) {
                      _filterArticles(query);
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search articles...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            : null,
        leading: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown, // This will scale the text to fit
                child: Text(
                  'News',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _filterArticles('');
                }
              });
            },
          ),
          const NotificationIcon(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Breaking News',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAll(
                                  title: 'Breaking News',
                                  articles: breakingNewsArticles,
                                )));
                  },
                  child: const Text('View all'),
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isExpanded ? 150 : 200,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    isExpanded = details.primaryDelta! > 5;
                  });
                },
                onVerticalDragEnd: (_) {
                  setState(() {
                    isExpanded = false;
                  });
                },
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredBreakingNews.length,
                  itemBuilder: (context, index) {
                    final article = filteredBreakingNews[index];

                    return Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Image.network(
                                article.imageUrl,
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'images/brat.webp',
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailNewsPage(
                                              article: article)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFEBD3F8),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffAD49E1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    article.newsSite,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                bottom: 10,
                                right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
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
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recommendation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAll(
                              title: 'Recommendations', articles: articles),
                        ));
                  },
                  child: const Text('View all'),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: ListView.builder(
                  itemCount: filteredRecommendations.length,
                  itemBuilder: (context, index) {
                    final article = filteredRecommendations[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailNewsPage(article: article),
                              ));
                        },
                        child: Card(
                          color: const Color(0xffEBD3F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                article.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'images/brat.webp',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              article.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  article.newsSite,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                                Text(
                                  article.publishedAt.substring(0, 10),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
