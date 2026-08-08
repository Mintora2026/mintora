import 'package:flutter/material.dart';

import '../models/record_model.dart';

class TimelineCard extends StatelessWidget {
  final RecordModel record;
  final VoidCallback? onTap;

  const TimelineCard({
    super.key,
    required this.record,
    this.onTap,
  });

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color softBorder = Color(0xFFE6EFE9);

  @override
  Widget build(BuildContext context) {
    final visual = _categoryVisual(record.category);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: softBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: visual.color.withValues(
                        alpha: 0.14,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      visual.icon,
                      color: visual.color,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          _categoryName(record.category),
                          style: const TextStyle(
                            color: Color(0xFF84948D),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: visual.color.withValues(
                        alpha: 0.10,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatTime(record.createdAt),
                      style: TextStyle(
                        color: visual.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                record.description.isEmpty
                    ? 'No additional details.'
                    : record.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF5F716A),
                  fontSize: 14,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F6ED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${record.growthPoints} Growth',
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const Spacer(),

                  if (onTap != null) ...[
                    const Text(
                      'View details',
                      style: TextStyle(
                        color: mintGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: mintGreen,
                      size: 18,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';

    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    return '$displayHour:$minute $period';
  }

  static String _categoryName(RecordCategory category) {
    switch (category) {
      case RecordCategory.mood:
        return 'Mood';

      case RecordCategory.sleep:
        return 'Sleep';

      case RecordCategory.work:
        return 'Work';

      case RecordCategory.study:
        return 'Study';

      case RecordCategory.finance:
        return 'Finance';

      case RecordCategory.health:
        return 'Health';

      case RecordCategory.exercise:
        return 'Exercise';

      case RecordCategory.water:
        return 'Water';

      case RecordCategory.memory:
        return 'Memory';

      case RecordCategory.other:
        return 'Other';
    }
  }

  static _CategoryVisual _categoryVisual(
    RecordCategory category,
  ) {
    switch (category) {
      case RecordCategory.mood:
        return const _CategoryVisual(
          icon: Icons.sentiment_satisfied_alt_rounded,
          color: Color(0xFFFFB85C),
        );

      case RecordCategory.sleep:
        return const _CategoryVisual(
          icon: Icons.bedtime_outlined,
          color: Color(0xFF7A91E8),
        );

      case RecordCategory.work:
        return const _CategoryVisual(
          icon: Icons.work_outline_rounded,
          color: Color(0xFF70A8F5),
        );

      case RecordCategory.study:
        return const _CategoryVisual(
          icon: Icons.menu_book_rounded,
          color: Color(0xFFA78BF0),
        );

      case RecordCategory.finance:
        return const _CategoryVisual(
          icon: Icons.account_balance_wallet_outlined,
          color: Color(0xFF64CFA1),
        );

      case RecordCategory.health:
        return const _CategoryVisual(
          icon: Icons.favorite_border_rounded,
          color: Color(0xFFFF8A8A),
        );

      case RecordCategory.exercise:
        return const _CategoryVisual(
          icon: Icons.directions_run_rounded,
          color: Color(0xFFFF9F68),
        );

      case RecordCategory.water:
        return const _CategoryVisual(
          icon: Icons.water_drop_outlined,
          color: Color(0xFF62B8F6),
        );

      case RecordCategory.memory:
        return const _CategoryVisual(
          icon: Icons.photo_album_outlined,
          color: Color(0xFFE58BC8),
        );

      case RecordCategory.other:
        return const _CategoryVisual(
          icon: Icons.auto_awesome_rounded,
          color: mintGreen,
        );
    }
  }
}

class _CategoryVisual {
  final IconData icon;
  final Color color;

  const _CategoryVisual({
    required this.icon,
    required this.color,
  });
}