import 'package:flutter/material.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF7FCF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  @override
  Widget build(BuildContext context) {
    final features = [
      const _FeatureItem(
        icon: Icons.favorite_border_rounded,
        title: 'Health',
        subtitle: 'Body & mind',
        color: Color(0xFFFF8A8A),
      ),
      const _FeatureItem(
        icon: Icons.work_outline_rounded,
        title: 'Work',
        subtitle: 'Career & progress',
        color: Color(0xFF70A8F5),
      ),
      const _FeatureItem(
        icon: Icons.menu_book_rounded,
        title: 'Learning',
        subtitle: 'Study & skills',
        color: Color(0xFFA78BF0),
      ),
      const _FeatureItem(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Finance',
        subtitle: 'Money & goals',
        color: Color(0xFF64CFA1),
      ),
      const _FeatureItem(
        icon: Icons.flag_outlined,
        title: 'Goals',
        subtitle: 'Dreams & plans',
        color: Color(0xFFFFB85C),
      ),
      const _FeatureItem(
        icon: Icons.park_outlined,
        title: 'Growth',
        subtitle: 'See your progress',
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
                46,
                24,
                110,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 760,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Everything in One Place',
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
                          'Bring the important parts of your life together.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF687C74),
                            fontSize: 17,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 34),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: features.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: 2.15,
                          ),
                          itemBuilder: (context, index) {
                            final item = features[index];

                            return Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: softBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: item.color.withValues(
                                        alpha: 0.14,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      item.icon,
                                      color: item.color,
                                      size: 27,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            color: darkGreen,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          item.subtitle,
                                          style: const TextStyle(
                                            color: Color(0xFF83938C),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
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
                                'One life. One timeline. One place to grow.',
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

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}