import 'package:cosmolot/pages/detail_page.dart';
import 'package:cosmolot/utils/rockets.api.dart';
import 'package:flutter/material.dart';
import 'package:cosmolot/models/file_article_rocket.dart';

class WatchPage extends StatefulWidget {
  const WatchPage({super.key});

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff9B7EBD),
      appBar: AppBar(
        backgroundColor: const Color(0xff9B7EBD),
        title: const Text(
          'SpaceX LaunchApp',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SpaceX Ships',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: jopa.length > 7 ? 7 : jopa.length,
                itemBuilder: (context, index) {
                  imageIndex = index;
                  final article = jopa[index];
                  return LaunchItemCard(article: article);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LaunchItemCard extends StatelessWidget {
  final RocketArticle article;

  const LaunchItemCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3C0753),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // Colțuri rotunjite
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Umbra
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(4, 4), // Deplasarea umbrei
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12), // Aceleași colțuri rotunjite
                  child: Image.asset(
                    article.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.originalLaunch,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    article.coreSerial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // GestureDetector applied to the Icon
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        article: article,
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.zoom_out_map,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
