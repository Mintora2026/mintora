import 'package:flutter/material.dart';

class MemorySection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int? count;
  final VoidCallback? onTap;
  final Widget child;

  const MemorySection({
    super.key,
    required this.title,
    this.subtitle,
    this.count,
    this.onTap,
    required this.child,
  });

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color lightGreen = Color(0xFFEAF7EF);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: darkGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: Color(0xFF7A8C84),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            if (onTap != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: onTap,
                tooltip: 'View all',
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: mintGreen,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}