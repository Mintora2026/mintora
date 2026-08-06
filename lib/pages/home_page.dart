import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color mintGreen = Color(0xFF67C78F);
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color lightGreen = Color(0xFFE7F6ED);
  static const Color pageBackground = Color(0xFFF6FBF8);

  static const int dailyActivityGoal = 7;

  @override
  Widget build(BuildContext context) {
    final repository = RecordRepository.instance;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        title: const Text(
          'Mintora',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: darkGreen,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, child) {
            final todayRecords = _getTodayRecords(repository.getAll());
            final completedActivities = todayRecords.length;
            final todayGrowthPoints = todayRecords.fold<int>(
              0,
              (sum, record) => sum + record.growthPoints,
            );

            final progress =
                (completedActivities / dailyActivityGoal).clamp(0.0, 1.0);
            final percentage = (progress * 100).round();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 22),
                  _buildGrowthCard(
                    completedActivities: completedActivities,
                    percentage: percentage,
                    progress: progress,
                    growthPoints: todayGrowthPoints,
                  ),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Quick Record'),
                  const SizedBox(height: 14),
                  _buildQuickRecordGrid(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Your Growth Tree'),
                  const SizedBox(height: 14),
                  _buildGrowthTreeCard(
                    completedActivities: completedActivities,
                    growthPoints: todayGrowthPoints,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<RecordModel> _getTodayRecords(List<RecordModel> records) {
    final now = DateTime.now();

    return records.where((record) {
      final date = record.createdAt;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;

    final greeting = hour < 12
        ? 'Good morning'
        : hour < 18
            ? 'Good afternoon'
            : 'Good evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Welcome back, Viola',
          style: TextStyle(
            color: darkGreen,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildGrowthCard({
    required int completedActivities,
    required int percentage,
    required double progress,
    required int growthPoints,
  }) {
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Today's Growth",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            completedActivities == 1
                ? 'You completed 1 activity and earned $growthPoints growth point today.'
                : 'You completed $completedActivities activities and earned $growthPoints growth points today.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF9EE76B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: darkGreen,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildQuickRecordGrid(BuildContext context) {
    final items = [
      const _QuickRecordItem(
        icon: Icons.sentiment_satisfied_alt_rounded,
        label: 'Mood',
        color: Color(0xFFFFC96B),
      ),
      const _QuickRecordItem(
        icon: Icons.bedtime_outlined,
        label: 'Sleep',
        color: Color(0xFF7A91E8),
      ),
      const _QuickRecordItem(
        icon: Icons.work_outline_rounded,
        label: 'Work',
        color: Color(0xFF70A8F5),
      ),
      const _QuickRecordItem(
        icon: Icons.menu_book_rounded,
        label: 'Study',
        color: Color(0xFFA78BF0),
      ),
      const _QuickRecordItem(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Finance',
        color: Color(0xFF64CFA1),
      ),
      const _QuickRecordItem(
        icon: Icons.favorite_border_rounded,
        label: 'Health',
        color: Color(0xFFFF8A8A),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item.label} selected'),
                duration: const Duration(milliseconds: 800),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE8F0EB),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item.label,
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrowthTreeCard({
    required int completedActivities,
    required int growthPoints,
  }) {
    final remaining =
        (dailyActivityGoal - completedActivities).clamp(0, dailyActivityGoal);

    final message = completedActivities >= dailyActivityGoal
        ? 'You reached today’s activity goal. Your tree is thriving.'
        : remaining == 1
            ? 'Complete one more activity today to help your tree grow.'
            : 'Complete $remaining more activities today to help your tree grow.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              _treeIcon(growthPoints),
              color: mintGreen,
              size: 58,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your tree is growing',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF557268),
                    height: 1.4,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _treeIcon(int growthPoints) {
    if (growthPoints >= 7) {
      return Icons.park_rounded;
    }

    if (growthPoints >= 3) {
      return Icons.eco_rounded;
    }

    return Icons.spa_rounded;
  }
}

class _QuickRecordItem {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickRecordItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}