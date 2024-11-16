import 'package:cosmolot/models/file_article_rocket.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final RocketArticle article;

  const DetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2E073F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C0753),
        title: const Text(
          'SpaceX Launch Details',
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
              // Title Section
              Center(
                child: Text(
                  article.coreSerial,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Image Section
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      article.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Grid Layout for Details Section
              GridView.builder(
                shrinkWrap:
                    true, // Allows the grid to take up only necessary space
                physics:
                    NeverScrollableScrollPhysics(), // Disable scrolling for this grid
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 16.0, // Space between columns
                  mainAxisSpacing: 16.0, // Space between rows
                ),
                itemCount: 4, // Number of items in the grid
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _buildInfoContainer(
                          'Missions',
                          article.missions.isNotEmpty
                              ? article.missions
                              : 'No missions available',
                          Colors.amber);
                    case 1:
                      return _buildInfoContainer('Original Launch',
                          article.originalLaunch, Colors.blue);
                    case 2:
                      return _buildInfoContainer(
                          'Status', article.status, Colors.green);
                    case 3:
                      return _buildInfoContainer(
                          'Reuse Count', article.reuseCount, Colors.pink);
                    default:
                      return const SizedBox(); // Default case for safety
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String label, String value, Color color) {
    return Container(
      height: 120, // Fixed height for uniformity
      decoration: BoxDecoration(
        color: Colors.deepPurple[700],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2, // Ensure text doesn't overflow
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
