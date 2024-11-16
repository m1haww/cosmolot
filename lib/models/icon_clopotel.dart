import 'package:cosmolot/utils/utils.api.dart';
import 'package:flutter/material.dart';

// Custom Widget for Notification Icon
class NotificationIcon extends StatelessWidget {
  const NotificationIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications_none),
      onPressed: () {
        _showNotificationSheet(context);
      },
    );
  }

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: const Color(0xff2E073F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Make text visible on dark background
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: articles.length, // Use your data source here
                    itemBuilder: (context, index) {
                      final article = articles[
                          index]; // Assuming articles is a list of Article objects
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              article
                                  .imageUrl, // Use the image URL from your data model
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'images/brat.webp', // Default fallback image
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          title: Text(
                            article
                                .title, // Display article title from your data
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // Text color to match the dark background
                            ),
                          ),
                          subtitle: Text(
                            'Published at: ${article.publishedAt.substring(0, 10)}', // Display the publication date
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors
                                  .grey[400], // Lighter grey text for subtitle
                            ),
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
      },
    );
  }
}
