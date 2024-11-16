int? imageIndex;

class RocketArticle {
  final String coreSerial;
  final String status;
  final String originalLaunch;
  final String missions;
  final String reuseCount;
  final String image;

  RocketArticle({
    required this.coreSerial,
    required this.status,
    required this.originalLaunch,
    required this.missions,
    required this.reuseCount,
    required this.image,
  });

  static RocketArticle fromJson(Map<String, dynamic> data) {
    String missions = '';
    if (data['missions'] != null && data['missions'] is List) {
      missions = (data['missions'] as List)
          .map((mission) => mission['name'] ?? 'Unknown')
          .join(', ');
    }

    List<String> defaultImages = [
      'images/bratan.jpg',
      'images/planet-581239_1280.webp',
      'images/rocket-ship-6995279_1280.jpg',
      'images/spacex-693229_1280.webp',
      "images/space-station-60615_1280.jpg",
      'images/spaceship-5570682_1280.webp',
      "images/spacecraft-441708_1280.webp",
    ];

    String image = defaultImages[imageIndex ?? 0];

    return RocketArticle(
      coreSerial: data['core_serial'] ?? 'Unknown',
      status: data['status'] ?? 'Unknown',
      originalLaunch: data['original_launch'] ?? 'Unknown',
      missions: missions.isNotEmpty ? missions : 'No missions',
      reuseCount: data['reuse_count']?.toString() ?? '0',
      image: image,
    );
  }

  static List<RocketArticle> fromJsonList(List<dynamic> data) {
    List<RocketArticle> list = [];
    for (int i = 0; i < 7; i++) {
      imageIndex = i;
      list.add(RocketArticle.fromJson(data[i]));
    }
    return list;
  }
}
