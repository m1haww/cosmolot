import 'dart:math';
import 'package:flutter/material.dart';

class InfoFinalPage extends StatefulWidget {
  const InfoFinalPage({Key? key}) : super(key: key);

  @override
  State<InfoFinalPage> createState() => _InfoFinalPageState();
}

class _InfoFinalPageState extends State<InfoFinalPage> {
  final List<String> _spaceImages = [
    'images/bratan.jpg',
    'images/planet-581239_1280.webp',
    'images/rocket-ship-6995279_1280.jpg',
    'images/spacex-693229_1280.webp',
    "images/space-station-60615_1280.jpg",
    'images/spaceship-5570682_1280.webp',
    "images/spacecraft-441708_1280.webp",
  ];

  final List<Color> _backgroundColors = [
    const Color(0xff7A1CAC),
    const Color(0xff9C27B0),
    const Color(0xff6A1B9A),
    const Color(0xff8E24AA),
    const Color(0xff512DA8),
    const Color(0xff673AB7),
  ];

  late String _currentImage;
  late Color _currentBackgroundColor;

  @override
  void initState() {
    super.initState();
    _switchBackgroundAndImage();
  }

  void _switchBackgroundAndImage() {
    final random = Random();
    setState(() {
      _currentImage = _spaceImages[random.nextInt(_spaceImages.length)];
      _currentBackgroundColor =
          _backgroundColors[random.nextInt(_backgroundColors.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentBackgroundColor,
      appBar: AppBar(
        title: const Text("Cosmic Info"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  _currentImage,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to the Cosmos!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Here are some fascinating facts about the universe:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "- The universe is approximately 13.8 billion years old.",
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const SizedBox(height: 10),
            const Text(
              "- There are more stars in the universe than grains of sand on Earth.",
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const SizedBox(height: 10),
            const Text(
              "- Light from the sun takes about 8 minutes to reach Earth.",
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            const Spacer(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the previous page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffAD49E1),
                ),
                child: const Text(
                  "Go Back",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
