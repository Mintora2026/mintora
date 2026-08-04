import 'package:flutter/material.dart';

class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color lightGreen = Color(0xFFE7F6ED);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Growth',
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
              Icons.insights_outlined,
              color: darkGreen,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your progress is becoming part of your story.',
                style: TextStyle(
                  color: Color(0xFF6B7F76),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _buildGrowthScoreCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Your Growth Tree'),
              const SizedBox(height: 14),
              _buildTreeCard(),
              const SizedBox(height: 24),
              _buildSectionTitle("Today's Goals"),
              const SizedBox(height: 14),
              _buildGoalsCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('This Month'),
              const SizedBox(height: 14),
              _buildMonthlyStats(),
              const SizedBox(height: 24),
              _buildCoachCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrowthScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF174C3C),
            Color(0xFF2E7A5E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Growth Score',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '78%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'You are making steady progress this week.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: LinearProgressIndicator(
              value: 0.78,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF9EE76B),
              ),
            ),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              _GrowthMetric(
                icon: Icons.local_fire_department_rounded,
                value: '12',
                label: 'Day streak',
              ),
              SizedBox(width: 24),
              _GrowthMetric(
                icon: Icons.check_circle_outline_rounded,
                value: '24',
                label: 'Completed',
              ),
              SizedBox(width: 24),
              _GrowthMetric(
                icon: Icons.auto_awesome_rounded,
                value: '340',
                label: 'Growth points',
              ),
            ],
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

  Widget _buildTreeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: const BoxDecoration(
              color: lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.park_rounded,
              color: mintGreen,
              size: 105,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Sprout Stage',
            style: TextStyle(
              color: darkGreen,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete 6 more activities to reach the next stage.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF667970),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0.64,
              minHeight: 9,
              backgroundColor: Color(0xFFEAF2ED),
              valueColor: AlwaysStoppedAnimation<Color>(mintGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsCard() {
    final goals = [
      const _GoalItem(
        icon: Icons.menu_book_rounded,
        title: 'Study',
        completed: true,
      ),
      const _GoalItem(
        icon: Icons.fitness_center_rounded,
        title: 'Workout',
        completed: true,
      ),
      const _GoalItem(
        icon: Icons.water_drop_outlined,
        title: 'Drink Water',
        completed: false,
      ),
      const _GoalItem(
        icon: Icons.bedtime_outlined,
        title: 'Sleep Before 11 PM',
        completed: false,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: goals
            .map(
              (goal) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        goal.icon,
                        color: darkGreen,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        goal.title,
                        style: TextStyle(
                          color: goal.completed
                              ? const Color(0xFF8A9A93)
                              : darkGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: goal.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    Icon(
                      goal.completed
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: goal.completed
                          ? mintGreen
                          : const Color(0xFFB8C6BF),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildMonthlyStats() {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.work_outline_rounded,
            value: '18',
            label: 'Work',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.school_outlined,
            value: '21',
            label: 'Study',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.favorite_border_rounded,
            value: '16',
            label: 'Health',
          ),
        ),
      ],
    );
  }

  Widget _buildCoachCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: mintGreen,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Growth Coach',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'You have been consistent with study and work. Add one health activity today to keep your growth balanced.',
                  style: TextStyle(
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
    );
  }
}

class _GrowthMetric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _GrowthMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalItem {
  final IconData icon;
  final String title;
  final bool completed;

  const _GoalItem({
    required this.icon,
    required this.title,
    required this.completed,
  });
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GrowthPage.softBorder),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: GrowthPage.mintGreen,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: GrowthPage.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6E8178),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}