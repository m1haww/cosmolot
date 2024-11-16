import 'dart:math';
import 'package:flutter/material.dart';

class SettingsP extends StatefulWidget {
  const SettingsP({super.key});

  @override
  State<SettingsP> createState() => _SettingsPState();
}

class _SettingsPState extends State<SettingsP> {
  Color _backgroundColor = Colors.deepPurple;
  String _currentImage = "images/bratan.jpg";
  final List<String> _spaceImages = [
    'images/bratan.jpg',
    'images/planet-581239_1280.webp',
    'images/rocket-ship-6995279_1280.jpg',
    'images/spacex-693229_1280.webp',
    "images/space-station-60615_1280.jpg",
    'images/spaceship-5570682_1280.webp',
    "images/spacecraft-441708_1280.webp",
  ];

  void _triggerRandomEvent() {
    final random = Random();
    setState(() {
      _backgroundColor = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );

      _currentImage = _spaceImages[random.nextInt(_spaceImages.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: double.infinity,
        color: _backgroundColor,
        child: SafeArea(
          child: Stack(
            children: [
              // Stars animation in the background
              const AnimatedStars(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(seconds: 2),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: ClipRRect(
                        key: ValueKey<String>(_currentImage),
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(seconds: 2),
                          child: Image.asset(
                            _currentImage,
                            width: double.infinity,
                            height: size.height * 0.4,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Cosmic Gift!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _triggerRandomEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Discover !",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedStars extends StatefulWidget {
  const AnimatedStars({super.key});

  @override
  _AnimatedStarsState createState() => _AnimatedStarsState();
}

class _AnimatedStarsState extends State<AnimatedStars>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();

    // Increase the duration significantly for slower movement
    _controllers = List.generate(
      30,
      (index) => AnimationController(
        duration: Duration(
            seconds: Random().nextInt(30) + 60), // Slower with much longer time
        vsync: this,
      )..repeat(reverse: true), // Make the animation repeat
    );

    _animations = List.generate(
      30,
      (index) {
        final random = Random();
        final offsetX = random.nextDouble() * 2 - 1; // Horizontal movement
        final offsetY = random.nextDouble() * 2 - 1; // Vertical movement

        return Tween<Offset>(
          begin: Offset(random.nextDouble() * 2 - 1,
              random.nextDouble() * 2 - 1), // Random starting position
          end: Offset(offsetX, offsetY), // Random ending position
        ).animate(CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeInOut,
        ));
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return Stack(
      children: List.generate(30, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            final size = random.nextInt(3) + 1.0; // Random size for stars
            final left = random.nextDouble() * 1.0;
            final top = random.nextDouble() * 1.0;

            return Positioned(
              left: _animations[index].value.dx *
                      MediaQuery.of(context).size.width +
                  left *
                      MediaQuery.of(context).size.width, // Covering whole width
              top: _animations[index].value.dy *
                      MediaQuery.of(context).size.height +
                  top *
                      MediaQuery.of(context)
                          .size
                          .height, // Covering whole height
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
