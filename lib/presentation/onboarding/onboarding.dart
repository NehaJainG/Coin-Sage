import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/strings.dart';
import 'package:coin_sage/main.dart';
import 'package:coin_sage/presentation/app_gate.dart';
import 'package:coin_sage/presentation/onboarding/onboarding_content.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  int _currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
    setSeenOnboard();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  AnimatedContainer dotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: index == _currentIndex ? lightGrey : BG,
        shape: BoxShape.circle,
      ),
    );
  }

  void setSeenOnboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    seenOnboard = prefs.setBool('seenOnboard', true) as bool?;
  }

  void startApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const AppGate(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onBoardingData.length,
                onPageChanged: (value) {
                  setState(
                    () {
                      _currentIndex = value;
                    },
                  );
                },
                itemBuilder: (context, index) {
                  return OnBoardingContent(
                    imagePath: onBoardingData[index]['imagePath']!,
                    title: onBoardingData[index]['title']!,
                    description: onBoardingData[index]['description']!,
                  );
                },
              ),
            ),
            _currentIndex == onBoardingData.length - 1
                ? Container(
                    decoration: BoxDecoration(
                      color: BG,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    child: TextButton(
                      onPressed: startApp,
                      child: const Text('Get Started'),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: startApp,
                        child: const Text('Skip'),
                      ),
                      Row(
                        children: List.generate(
                          onBoardingData.length,
                          (index) => dotIndicator(index),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
