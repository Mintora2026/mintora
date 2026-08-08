import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main_shell.dart';
import 'features_page.dart';
import 'growth_page.dart';
import 'welcome_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF7FCF8);

  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Widget> _pages = const [
    WelcomePage(),
    FeaturesPage(),
    GrowthOnboardingPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }

    _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      'hasCompletedOnboarding',
      true,
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return const MainShell();
        },
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: _pages,
              ),
            ),

            Positioned(
              top: 8,
              right: 18,
              child: AnimatedOpacity(
                opacity: isLastPage ? 0 : 1,
                duration: const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: isLastPage,
                  child: TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF71857C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 24,
              right: 24,
              bottom: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) {
                        final selected = index == _currentPage;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          width: selected ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: selected
                                ? mintGreen
                                : const Color(0xFFD3E2DA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 420,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _goNext,
                        style: FilledButton.styleFrom(
                          backgroundColor: darkGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          isLastPage
                              ? 'Start Your Journey'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}