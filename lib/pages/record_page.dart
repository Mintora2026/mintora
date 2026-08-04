import 'package:flutter/material.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color pageBackground = Color(0xFFF6FBF8);

  @override
  Widget build(BuildContext context) {
    final items = [
      const _RecordItem(
        icon: Icons.sentiment_satisfied_alt_rounded,
        label: 'Mood',
        subtitle: 'How do you feel?',
        color: Color(0xFFFFC96B),
      ),
      const _RecordItem(
        icon: Icons.bedtime_outlined,
        label: 'Sleep',
        subtitle: 'Track your rest',
        color: Color(0xFF7A91E8),
      ),
      const _RecordItem(
        icon: Icons.work_outline_rounded,
        label: 'Work',
        subtitle: 'Record progress',
        color: Color(0xFF70A8F5),
      ),
      const _RecordItem(
        icon: Icons.menu_book_rounded,
        label: 'Study',
        subtitle: 'Save learning',
        color: Color(0xFFA78BF0),
      ),
      const _RecordItem(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Finance',
        subtitle: 'Track money',
        color: Color(0xFF64CFA1),
      ),
      const _RecordItem(
        icon: Icons.favorite_border_rounded,
        label: 'Health',
        subtitle: 'Record wellness',
        color: Color(0xFFFF8A8A),
      ),
      const _RecordItem(
        icon: Icons.directions_run_rounded,
        label: 'Exercise',
        subtitle: 'Log activity',
        color: Color(0xFFFF9F68),
      ),
      const _RecordItem(
        icon: Icons.water_drop_outlined,
        label: 'Water',
        subtitle: 'Track hydration',
        color: Color(0xFF62B8F6),
      ),
    ];

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        title: const Text(
          'Quick Record',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${item.label} recording will be added next.',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Done'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFE7EFEA),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 27,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.label,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RecordItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;

  const _RecordItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
  });
}