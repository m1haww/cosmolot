import 'package:cosmolot/pages/main_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingPages extends StatefulWidget {
  const OnboardingPages({super.key});

  @override
  State<OnboardingPages> createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "images/onboarding1.jpg",
      "title": "Welcome to Cosmo Info",
      "description":
          "Stay updated with the latest news on space exploration, technology, and scientific discoveries."
    },
    {
      "image": "images/onboarding2.webp",
      "title": "Space News at Your Fingertips",
      "description":
          "Access the latest space news, launch updates, and breakthroughs at your fingertips."
    },
    {
      "image": "images/onboarding3.jpg",
      "title": "Engage with the Community",
      "description":
          "Join discussions and explore the wonders of the universe with like-minded space enthusiasts."
    },
  ];

  // Navigate to the next page
  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const MainNavigation(),
        ),
      );
    }
  }

  // Skip to the home page
  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Onboarding PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Onboarding Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          _onboardingData[index]['image']!,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Onboarding Title
                      Text(
                        _onboardingData[index]['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Onboarding Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          _onboardingData[index]['description']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),

          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_onboardingData.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                height: 8.0,
                width: _currentPage == index ? 24.0 : 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xff9B7EBD)
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Buttons for navigation
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                if (_currentPage < _onboardingData.length - 1)
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Next / Start Button
                ElevatedButton(
                  onPressed: _currentPage == _onboardingData.length - 1
                      ? _skipOnboarding
                      : _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    backgroundColor: const Color(0xff9B7EBD),
                  ),
                  child: Text(
                    _currentPage == _onboardingData.length - 1
                        ? "Start"
                        : "Next",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.035),
        ],
      ),
    );
  }
}

// Placeholder for HomePage
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: const Center(
        child: Text("Welcome to Cosmo Info News!"),
      ),
    );
  }
}
