import 'package:flutter/material.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE6EFE9);

  @override
  Widget build(BuildContext context) {
    final entries = <TimelineEntry>[
      const TimelineEntry(
        time: '9:30 AM',
        title: 'Mood',
        description: 'Feeling happy and ready for the day.',
        icon: Icons.sentiment_satisfied_alt_rounded,
        color: Color(0xFFFFB85C),
      ),
      const TimelineEntry(
        time: '10:20 AM',
        title: 'Work',
        description: 'Completed the first Mintora navigation framework.',
        icon: Icons.work_outline_rounded,
        color: Color(0xFF70A8F5),
      ),
      const TimelineEntry(
        time: '8:40 PM',
        title: 'Study',
        description: 'Reviewed an MBA chapter and organized notes.',
        icon: Icons.menu_book_rounded,
        color: Color(0xFFA78BF0),
      ),
    ];

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
        child: ListView(
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
            ...List.generate(
              entries.length,
              (index) => _TimelineItem(
                entry: entries[index],
                isLast: index == entries.length - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 58,
          decoration: BoxDecoration(
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
                '04',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'AUG',
                style: TextStyle(
                  color: mintGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: TextStyle(
                color: darkGreen,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Tuesday',
              style: TextStyle(
                color: Color(0xFF7A8C84),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final TimelineEntry entry;
  final bool isLast;

  const _TimelineItem({
    required this.entry,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: entry.color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    entry.icon,
                    color: entry.color,
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
                            entry.title,
                            style: const TextStyle(
                              color: TimelinePage.darkGreen,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          entry.time,
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
                      entry.description,
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
}

class TimelineEntry {
  final String time;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const TimelineEntry({
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}