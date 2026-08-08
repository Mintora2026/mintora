import 'package:flutter/material.dart';

class MemoryHeader extends StatelessWidget {
  final int totalMemories;
  final int thisMonth;
  final int thisYear;

  const MemoryHeader({
    super.key,
    required this.totalMemories,
    required this.thisMonth,
    required this.thisYear,
  });

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color lightGreen = Color(0xFFEAF7EF);
  static const Color softBorder = Color(0xFFE5EEE8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF174C3C),
            Color(0xFF2D7A5E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your Memories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Meaningful moments become part of your story.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _MemoryMetric(
                  label: 'All Memories',
                  value: '$totalMemories',
                  icon: Icons.collections_bookmark_outlined,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _MemoryMetric(
                  label: 'This Month',
                  value: '$thisMonth',
                  icon: Icons.calendar_month_outlined,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _MemoryMetric(
                  label: 'This Year',
                  value: '$thisYear',
                  icon: Icons.history_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemoryMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MemoryMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 19,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}