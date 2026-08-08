import 'package:flutter/material.dart';

class GrowthOnboardingPage extends StatelessWidget {
  const GrowthOnboardingPage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF7FCF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  @override
  Widget build(BuildContext context) {
    final stages = [
      const _GrowthStage(
        title: 'Seed',
        subtitle: 'Every journey starts small.',
        icon: Icons.grass_rounded,
        color: Color(0xFFB98A55),
      ),
      const _GrowthStage(
        title: 'Sprout',
        subtitle: 'Small actions begin to take root.',
        icon: Icons.spa_rounded,
        color: Color(0xFF7BCB82),
      ),
      const _GrowthStage(
        title: 'Young Tree',
        subtitle: 'Consistency turns into visible growth.',
        icon: Icons.eco_rounded,
        color: Color(0xFF58B978),
      ),
      const _GrowthStage(
        title: 'Flourishing Tree',
        subtitle: 'Your progress becomes part of your story.',
        icon: Icons.park_rounded,
        color: mintGreen,
      ),
    ];

    return ColoredBox(
      color: pageBackground,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                44,
                24,
                110,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 820,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Grow Every Day',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkGreen,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Your everyday actions become visible progress over time.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF687C74),
                            fontSize: 17,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: softBorder,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEAF7EF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.park_rounded,
                                  color: mintGreen,
                                  size: 54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Your Growth Tree',
                                style: TextStyle(
                                  color: darkGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Every record, habit, goal, and meaningful moment can help your tree grow.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF61746C),
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: List.generate(
                            stages.length,
                            (index) {
                              final stage = stages[index];

                              return Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _StageCard(
                                        stage: stage,
                                      ),
                                    ),
                                    if (index != stages.length - 1)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Color(0xFFC2D1C9),
                                          size: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF7EF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: mintGreen,
                                size: 20,
                              ),
                              SizedBox(width: 9),
                              Text(
                                'Small actions today can grow into a meaningful future.',
                                style: TextStyle(
                                  color: darkGreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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

class _StageCard extends StatelessWidget {
  final _GrowthStage stage;

  const _StageCard({
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: stage.color.withValues(
              alpha: 0.14,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            stage.icon,
            color: stage.color,
            size: 31,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          stage.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: GrowthOnboardingPage.darkGreen,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stage.subtitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF86958F),
            fontSize: 10,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _GrowthStage {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _GrowthStage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}