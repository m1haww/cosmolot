import 'dart:io';
import 'dart:math';
import 'package:cosmolot/models/info_final_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsP extends StatefulWidget {
  const SettingsP({super.key});

  @override
  State<SettingsP> createState() => _SettingsPState();
}

class _SettingsPState extends State<SettingsP> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

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

  // List of background colors
  final List<Color> _backgroundColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.indigo,
    Colors.pink,
  ];

  void _triggerRandomEvent() {
    final random = Random();
    setState(() {
      // Randomly select a background color
      _backgroundColor =
          _backgroundColors[random.nextInt(_backgroundColors.length)];

      // Randomly select an image from the list
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
              const AnimatedStars(),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.height * 0.15,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black45, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.075),
                        child: _image == null
                            ? Image.asset(
                                'images/avatar_default.jpg',
                                fit: BoxFit.contain,
                              )
                            : Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
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
                    onPressed: () {
                      // Show a dialog with a fun message when the "Discover" button is pressed
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Cosmic Discovery!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const Text(
                              'You have discovered something amazing in the cosmos!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const InfoFinalPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffAD49E1),
                                ),
                                child: const Text(
                                  'Proceed',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2E073F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Discover',
                      style: TextStyle(
                        color: Color(0xffF5CCA0),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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
