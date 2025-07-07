import 'package:e_commerce/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
              // Last index (change if more screens)
            });
          },
          children: const [
            OnboardPage(
              title: "Welcome",
              description: "Discover amazing features in our app.",
              imagePath: "assets/images/onboard1.png",
            ),
            OnboardPage(
              title: "Track Your Orders",
              description: "Easily manage and track everything.",
              imagePath: "assets/images/onboard2.png",
            ),
            OnboardPage(
              title: "Get Started",
              description: "Let’s get you signed in and started.",
              imagePath: "assets/images/onboard3.png",
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => _controller.jumpToPage(2),
              child: const Text("Skip"),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                  activeDotColor: Colors.deepPurple,
                ),
              ),
            ),
            isLastPage
                ? TextButton(
    onPressed: () {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => LoginPage()),
    );
    },
              child: const Text("Start"),
            )
                : TextButton(
              onPressed: () {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 300),
        const SizedBox(height: 40),
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
