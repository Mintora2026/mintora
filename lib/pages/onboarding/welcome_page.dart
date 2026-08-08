import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF7FCF8);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: pageBackground,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 12,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 460,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 156,
                          height: 156,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(38),
                            border: Border.all(
                              color: const Color(0xFFE5EEE8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.055,
                                ),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'Mintora',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkGreen,
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Welcome to Mintora',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF18201D),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 26),

                        const Text(
                          'Organize Your Life.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkGreen,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Preserve Your Memories.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF58736A),
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Grow Your Future.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: mintGreen,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 26),

                        const Text(
                          'Everything starts with one small step.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF879790),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}