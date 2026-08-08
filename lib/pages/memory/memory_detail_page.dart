import 'package:flutter/material.dart';

import '../../models/record_model.dart';

class MemoryDetailPage extends StatelessWidget {
  final RecordModel memory;

  const MemoryDetailPage({
    super.key,
    required this.memory,
  });

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        title: const Text(
          'Memory',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: softBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_stories_rounded,
                    color: mintGreen,
                    size: 34,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    memory.title,
                    style: const TextStyle(
                      color: darkGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _formatDate(memory.createdAt),
                    style: const TextStyle(
                      color: Color(0xFF7A8C84),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    memory.description.trim().isEmpty
                        ? 'A moment worth remembering.'
                        : memory.description,
                    style: const TextStyle(
                      color: Color(0xFF52675E),
                      fontSize: 15,
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7EF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '+${memory.growthPoints} Growth',
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
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

  static String _formatDate(DateTime date) {
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

    return '${months[date.month - 1]} ${date.day}, ${date.year} • ${_formatTime(date)}';
  }

  static String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';

    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    return '$displayHour:$minute $period';
  }
}