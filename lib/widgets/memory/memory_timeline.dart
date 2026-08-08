import 'package:flutter/material.dart';

import '../../models/record_model.dart';
import 'memory_card.dart';

class MemoryTimeline extends StatelessWidget {
  final Map<DateTime, List<RecordModel>> groupedMemories;
  final void Function(RecordModel memory)? onMemoryTap;

  const MemoryTimeline({
    super.key,
    required this.groupedMemories,
    this.onMemoryTap,
  });

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color softBorder = Color(0xFFE5EEE8);

  @override
  Widget build(BuildContext context) {
    if (groupedMemories.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 40,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: softBorder,
          ),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.auto_stories_outlined,
              color: mintGreen,
              size: 42,
            ),
            SizedBox(height: 14),
            Text(
              'No memories yet',
              style: TextStyle(
                color: darkGreen,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Save a meaningful moment and it will become part of your story.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B7D75),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    final entries = groupedMemories.entries.toList()
      ..sort(
        (a, b) => b.key.compareTo(a.key),
      );

    return Column(
      children: List.generate(
        entries.length,
        (index) {
          final entry = entries[index];
          final date = entry.key;
          final memories = entry.value;

          return Column(
            children: [
              _MemoryDateHeader(
                date: date,
                count: memories.length,
              ),
              const SizedBox(height: 14),
              ...List.generate(
                memories.length,
                (memoryIndex) {
                  final memory = memories[memoryIndex];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: memoryIndex ==
                              memories.length - 1
                          ? 22
                          : 12,
                    ),
                    child: MemoryCard(
                      memory: memory,
                      onTap: onMemoryTap == null
                          ? null
                          : () {
                              onMemoryTap!(memory);
                            },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MemoryDateHeader extends StatelessWidget {
  final DateTime date;
  final int count;

  const _MemoryDateHeader({
    required this.date,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: MemoryTimeline.softBorder,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date.day.toString().padLeft(2, '0'),
                style: const TextStyle(
                  color: MemoryTimeline.darkGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                _monthShort(date.month),
                style: const TextStyle(
                  color: MemoryTimeline.mintGreen,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _title(date),
                style: const TextStyle(
                  color: MemoryTimeline.darkGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                _subtitle(date),
                style: const TextStyle(
                  color: Color(0xFF7A8C84),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7EF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: MemoryTimeline.darkGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  static String _title(DateTime date) {
    final today = _dateOnly(
      DateTime.now(),
    );

    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    if (_sameDate(date, today)) {
      return 'Today';
    }

    if (_sameDate(date, yesterday)) {
      return 'Yesterday';
    }

    return _weekday(date.weekday);
  }

  static String _subtitle(DateTime date) {
    return '${_monthFull(date.month)} ${date.day}, ${date.year}';
  }

  static String _monthShort(int month) {
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

  static String _monthFull(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  static String _weekday(int weekday) {
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

  static DateTime _dateOnly(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  static bool _sameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}