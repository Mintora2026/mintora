import 'package:flutter/material.dart';

void main() {
  runApp(const MintoraApp());
}

class MintoraApp extends StatelessWidget {
  const MintoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mintora',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF6FBF8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF67C78F),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color mintGreen = Color(0xFF67C78F);
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color lightGreen = Color(0xFFE7F6ED);
  static const Color pageBackground = Color(0xFFF6FBF8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildGrowthCard(),
              const SizedBox(height: 28),
              _buildSectionTitle(
                title: 'Quick Record',
                actionText: 'View all',
              ),
              const SizedBox(height: 14),
              _buildQuickRecordGrid(),
              const SizedBox(height: 28),
              _buildSectionTitle(
                title: 'Your Growth Tree',
                actionText: 'Explore',
              ),
              const SizedBox(height: 14),
              _buildGrowthTreeCard(),
              const SizedBox(height: 28),
              _buildSectionTitle(
                title: 'Recent Timeline',
                actionText: 'See all',
              ),
              const SizedBox(height: 14),
              _buildTimelineCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.asset(
              'assets/images/app_icon.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Welcome to Mintora',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: darkGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildGrowthCard() {
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
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.20),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
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
                '68%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'You completed 5 of 7 daily activities.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.68,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF9EE76B),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              _GrowthMetric(
                icon: Icons.local_fire_department_outlined,
                value: '5',
                label: 'Activities',
              ),
              SizedBox(width: 28),
              _GrowthMetric(
                icon: Icons.park_outlined,
                value: '12',
                label: 'Day streak',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String actionText,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          actionText,
          style: const TextStyle(
            color: mintGreen,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickRecordGrid() {
    const items = [
      _QuickRecordItem(
        icon: Icons.sentiment_satisfied_alt_rounded,
        label: 'Mood',
        color: Color(0xFFFFC96B),
      ),
      _QuickRecordItem(
        icon: Icons.work_outline_rounded,
        label: 'Work',
        color: Color(0xFF70A8F5),
      ),
      _QuickRecordItem(
        icon: Icons.menu_book_rounded,
        label: 'Study',
        color: Color(0xFFA78BF0),
      ),
      _QuickRecordItem(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Finance',
        color: Color(0xFF64CFA1),
      ),
      _QuickRecordItem(
        icon: Icons.favorite_border_rounded,
        label: 'Health',
        color: Color(0xFFFF8A8A),
      ),
      _QuickRecordItem(
        icon: Icons.add_rounded,
        label: 'More',
        color: Color(0xFF9DA8AE),
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
        childAspectRatio: 0.94,
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
                    color: item.color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 11),
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

  Widget _buildGrowthTreeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(
              Icons.park_rounded,
              color: mintGreen,
              size: 65,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your tree is growing',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Record one more activity today to help your tree grow.',
                  style: TextStyle(
                    color: Color(0xFF557268),
                    height: 1.45,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Icon(
                      Icons.eco_outlined,
                      color: mintGreen,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Level 2 · Young Sprout',
                      style: TextStyle(
                        color: mintGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE8F0EB),
        ),
      ),
      child: const Row(
        children: [
          _TimelineDate(),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed MBA study session',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Study · 45 minutes',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: 0,
      height: 74,
      backgroundColor: Colors.white,
      indicatorColor: lightGreen,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home_rounded,
            color: darkGreen,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.timeline_outlined),
          selectedIcon: Icon(
            Icons.timeline_rounded,
            color: darkGreen,
          ),
          label: 'Timeline',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline_rounded),
          selectedIcon: Icon(
            Icons.add_circle_rounded,
            color: mintGreen,
          ),
          label: 'Record',
        ),
        NavigationDestination(
          icon: Icon(Icons.park_outlined),
          selectedIcon: Icon(
            Icons.park_rounded,
            color: darkGreen,
          ),
          label: 'Growth',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(
            Icons.person_rounded,
            color: darkGreen,
          ),
          label: 'Profile',
        ),
      ],
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
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF9EE76B),
          size: 21,
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: 13,
          ),
        ),
      ],
    );
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

class _TimelineDate extends StatelessWidget {
  const _TimelineDate();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 62,
      decoration: BoxDecoration(
        color: const Color(0xFFE7F6ED),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '03',
            style: TextStyle(
              color: Color(0xFF174C3C),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'AUG',
            style: TextStyle(
              color: Color(0xFF67C78F),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}