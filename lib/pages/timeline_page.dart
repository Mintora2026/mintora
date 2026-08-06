import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE6EFE9);

  @override
  Widget build(BuildContext context) {
    final repository = RecordRepository.instance;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Timeline',
          style: TextStyle(
            color: darkGreen,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
              color: darkGreen,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, child) {
            final records = repository.getAll();

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
              children: [
                const Text(
                  'Your life, organized by time.',
                  style: TextStyle(
                    color: Color(0xFF6B7D75),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                _buildDateHeader(),
                const SizedBox(height: 18),
                if (records.isEmpty)
                  const _EmptyTimeline()
                else
                  ...List.generate(
                    records.length,
                    (index) => _TimelineItem(
                      record: records[index],
                      isLast: index == records.length - 1,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    final now = DateTime.now();

    return Row(
      children: [
        Container(
          width: 48,
          height: 58,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            border: Border.fromBorderSide(
              BorderSide(color: softBorder),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                now.day.toString().padLeft(2, '0'),
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                _monthName(now.month),
                style: const TextStyle(
                  color: mintGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today',
              style: TextStyle(
                color: darkGreen,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _weekdayName(now.weekday),
              style: const TextStyle(
                color: Color(0xFF7A8C84),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _monthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return months[month - 1];
  }

  static String _weekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return weekdays[weekday - 1];
  }
}

class _TimelineItem extends StatelessWidget {
  final RecordModel record;
  final bool isLast;

  const _TimelineItem({
    required this.record,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final visual = _categoryVisual(record.category);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 54,
            child: Column(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: visual.color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    visual.icon,
                    color: visual.color,
                    size: 23,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      color: const Color(0xFFDDE9E2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: TimelinePage.softBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            record.title,
                            style: const TextStyle(
                              color: TimelinePage.darkGreen,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(record.createdAt),
                          style: const TextStyle(
                            color: Color(0xFF86958F),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      record.description,
                      style: const TextStyle(
                        color: Color(0xFF5F716A),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

  static _CategoryVisual _categoryVisual(RecordCategory category) {
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
          color: TimelinePage.mintGreen,
        );
    }
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 42,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: TimelinePage.softBorder,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.history_rounded,
            color: TimelinePage.mintGreen,
            size: 44,
          ),
          SizedBox(height: 14),
          Text(
            'No records yet',
            style: TextStyle(
              color: TimelinePage.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first record and it will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
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