import 'package:flutter/material.dart';

class AiInsightCard extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onTap;

  const AiInsightCard({
    super.key,
    this.title = 'AI Insight',
    required this.message,
    this.onTap,
  });

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color lightGreen = Color(0xFFEAF7EF);
  static const Color softBorder = Color(0xFFDDEBE3);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: softBorder,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: mintGreen,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: darkGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (onTap != null)
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: mintGreen,
                            size: 20,
                          ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Text(
                      message,
                      style: const TextStyle(
                        color: Color(0xFF557268),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}