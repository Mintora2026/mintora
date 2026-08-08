import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../services/insight_service.dart';
import '../widgets/ai_insight_card.dart';

class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color lightGreen = Color(0xFFE7F6ED);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  @override
  Widget build(BuildContext context) {
    final repository = RecordRepository.instance;
    final insightService = InsightService.instance;

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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Advanced insights will be added later.',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.insights_outlined,
              color: darkGreen,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, child) {
            final records = [...repository.getAll()]
              ..sort(
                (a, b) => b.createdAt.compareTo(
                  a.createdAt,
                ),
              );

            final todayGrowth = _growthForDate(
              records,
              DateTime.now(),
            );

            final totalGrowth =
                insightService.calculateGrowthPoints(
              records,
            );

            final weeklyGrowth =
                insightService.calculateGrowthPoints(
              records,
              days: 7,
            );

            final activeDays =
                insightService.calculateActiveDays(
              records,
              days: 7,
            );

            final streak =
                insightService.calculateCurrentStreak(
              records,
            );

            final weekData = _buildLast7Days(
              records,
            );

            final stage = _growthStage(
              totalGrowth,
            );

            final categoryGrowth =
                insightService.calculateCategoryGrowth(
              records,
            );

            final contributions =
                _buildCategoryContributions(
              categoryGrowth,
            );

            final recentGrowth =
                records.take(5).toList();

            final growthScore =
                _calculateWeeklyScore(
              weeklyGrowth,
              activeDays,
            );

            final growthInsight =
                insightService.buildGrowthInsight(
              records,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                110,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'See how your everyday actions are shaping your growth.',
                    style: TextStyle(
                      color: Color(0xFF6B7F76),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _buildGrowthScoreCard(
                    score: growthScore,
                    streak: streak,
                    activeDays: activeDays,
                    weeklyGrowth: weeklyGrowth,
                  ),

                  const SizedBox(height: 28),

                  _buildSectionHeader(
                    title: 'Your Growth Tree',
                    subtitle:
                        'Your tree grows from your total lifetime progress.',
                  ),

                  const SizedBox(height: 14),

                  _buildTreeCard(
                    stage: stage,
                    todayGrowth: todayGrowth,
                    totalGrowth: totalGrowth,
                  ),

                  const SizedBox(height: 28),

                  _buildSectionHeader(
                    title: 'Last 7 Days',
                    subtitle:
                        '$weeklyGrowth growth points earned this week.',
                  ),

                  const SizedBox(height: 14),

                  _buildWeekCard(
                    weekData,
                  ),

                  const SizedBox(height: 28),

                  _buildSectionHeader(
                    title: 'Growth by Category',
                    subtitle:
                        'See which parts of your life are contributing most.',
                  ),

                  const SizedBox(height: 14),

                  _buildContributionCard(
                    contributions,
                  ),

                  const SizedBox(height: 28),

                  _buildSectionHeader(
                    title: 'Recent Growth',
                    subtitle:
                        'Your latest actions that helped your tree grow.',
                  ),

                  const SizedBox(height: 14),

                  _buildRecentGrowthCard(
                    recentGrowth,
                  ),

                  const SizedBox(height: 28),

                  AiInsightCard(
                    title: 'Growth Insight',
                    message: growthInsight,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: darkGreen,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF7A8C84),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildGrowthScoreCard({
    required int score,
    required int streak,
    required int activeDays,
    required int weeklyGrowth,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Weekly Growth',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$score%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            _weeklyMessage(score),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Color(0xFF9EE76B),
              ),
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _GrowthMetric(
                  icon: Icons.local_fire_department_rounded,
                  value: '$streak',
                  label: 'Day streak',
                ),
              ),
              Expanded(
                child: _GrowthMetric(
                  icon: Icons.calendar_today_outlined,
                  value: '$activeDays',
                  label: 'Active days',
                ),
              ),
              Expanded(
                child: _GrowthMetric(
                  icon: Icons.auto_awesome_rounded,
                  value: '$weeklyGrowth',
                  label: 'Week points',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTreeCard({
    required _GrowthStageData stage,
    required int todayGrowth,
    required int totalGrowth,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: softBorder,
        ),
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
            child: Icon(
              stage.icon,
              color: mintGreen,
              size: 105,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Level ${stage.level}',
              style: const TextStyle(
                color: darkGreen,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            stage.name,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            stage.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF667970),
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _TreeMetricCard(
                  label: 'Today',
                  value: '+$todayGrowth',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TreeMetricCard(
                  label: 'Total Growth',
                  value: '$totalGrowth',
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: Text(
                  stage.isMaxLevel
                      ? 'Maximum stage reached'
                      : 'Progress to ${stage.nextStageName}',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${(stage.progress * 100).round()}%',
                style: const TextStyle(
                  color: mintGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: stage.progress,
              minHeight: 10,
              backgroundColor:
                  const Color(0xFFEAF2ED),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                mintGreen,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            stage.isMaxLevel
                ? 'Keep growing your life story.'
                : '${stage.pointsRemaining} growth points until ${stage.nextStageName}.',
            style: const TextStyle(
              color: Color(0xFF75877F),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCard(
    List<_DayGrowth> days,
  ) {
    var maxPoints = 1;

    for (final day in days) {
      if (day.points > maxPoints) {
        maxPoints = day.points;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        22,
        18,
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: SizedBox(
        height: 145,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: days.map((day) {
            final heightFactor = day.points == 0
                ? 0.05
                : day.points / maxPoints;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${day.points}',
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor:
                              heightFactor.clamp(
                            0.05,
                            1.0,
                          ),
                          child: Container(
                            width: 28,
                            decoration: BoxDecoration(
                              color: day.isToday
                                  ? darkGreen
                                  : mintGreen.withValues(
                                      alpha: 0.55,
                                    ),
                              borderRadius:
                                  BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      day.label,
                      style: TextStyle(
                        color: day.isToday
                            ? darkGreen
                            : const Color(
                                0xFF7A8C84,
                              ),
                        fontSize: 11,
                        fontWeight: day.isToday
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContributionCard(
    List<_CategoryContribution> contributions,
  ) {
    if (contributions.isEmpty) {
      return _buildEmptyCard(
        icon: Icons.pie_chart_outline_rounded,
        title: 'No growth data yet',
        message:
            'Create records to see which areas of your life are contributing to your growth.',
      );
    }

    final total = contributions.fold<int>(
      0,
      (sum, item) => sum + item.points,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Column(
        children: contributions.map((item) {
          final progress =
              total == 0 ? 0.0 : item.points / total;

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 9,
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: item.color.withValues(
                      alpha: 0.14,
                    ),
                    borderRadius: BorderRadius.circular(
                      13,
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.label,
                              style: const TextStyle(
                                color: darkGreen,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            '${item.points} pts',
                            style: const TextStyle(
                              color: Color(
                                0xFF6B7D75,
                              ),
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                        child:
                            LinearProgressIndicator(
                          value: progress,
                          minHeight: 7,
                          backgroundColor:
                              const Color(
                            0xFFF0F4F2,
                          ),
                          valueColor:
                              AlwaysStoppedAnimation<
                                  Color>(
                            item.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentGrowthCard(
    List<RecordModel> records,
  ) {
    if (records.isEmpty) {
      return _buildEmptyCard(
        icon: Icons.history_rounded,
        title: 'No recent growth',
        message:
            'Your latest records will appear here.',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Column(
        children: List.generate(
          records.length,
          (index) {
            final record = records[index];

            final visual = _categoryVisual(
              record.category,
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: visual.color.withValues(
                            alpha: 0.14,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            13,
                          ),
                        ),
                        child: Icon(
                          visual.icon,
                          color: visual.color,
                          size: 21,
                        ),
                      ),

                      const SizedBox(width: 13),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.title,
                              style: const TextStyle(
                                color: darkGreen,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _formatRecordDate(
                                record.createdAt,
                              ),
                              style: const TextStyle(
                                color: Color(
                                  0xFF85958E,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: Text(
                          '+${record.growthPoints}',
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (index != records.length - 1)
                  const Divider(
                    color: softBorder,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 36,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: mintGreen,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  int _growthForDate(
    List<RecordModel> records,
    DateTime date,
  ) {
    return records
        .where(
          (record) => _sameDate(
            record.createdAt,
            date,
          ),
        )
        .fold<int>(
          0,
          (sum, record) =>
              sum + record.growthPoints,
        );
  }

  List<_DayGrowth> _buildLast7Days(
    List<RecordModel> records,
  ) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final days = <_DayGrowth>[];

    for (var offset = 6;
        offset >= 0;
        offset--) {
      final date = today.subtract(
        Duration(
          days: offset,
        ),
      );

      final points = _growthForDate(
        records,
        date,
      );

      days.add(
        _DayGrowth(
          label: _weekdayShort(
            date.weekday,
          ),
          points: points,
          isToday: offset == 0,
        ),
      );
    }

    return days;
  }

  int _calculateWeeklyScore(
    int weeklyGrowth,
    int activeDays,
  ) {
    final growthScore =
        (weeklyGrowth / 21) * 70;

    final consistencyScore =
        (activeDays / 7) * 30;

    return (growthScore + consistencyScore)
        .round()
        .clamp(
          0,
          100,
        );
  }

  List<_CategoryContribution>
      _buildCategoryContributions(
    Map<RecordCategory, int> categoryGrowth,
  ) {
    final list =
        <_CategoryContribution>[];

    for (final entry
        in categoryGrowth.entries) {
      if (entry.key == RecordCategory.memory ||
          entry.key == RecordCategory.other) {
        continue;
      }

      final visual = _categoryVisual(
        entry.key,
      );

      list.add(
        _CategoryContribution(
          label:
              InsightService.instance.categoryName(
            entry.key,
          ),
          points: entry.value,
          icon: visual.icon,
          color: visual.color,
        ),
      );
    }

    list.sort(
      (a, b) =>
          b.points.compareTo(a.points),
    );

    return list;
  }

  String _weeklyMessage(
    int score,
  ) {
    if (score >= 85) {
      return 'Excellent consistency. Your week is showing strong momentum.';
    }

    if (score >= 65) {
      return 'You are building steady momentum this week.';
    }

    if (score >= 40) {
      return 'Your week is taking shape. A little more consistency will help.';
    }

    if (score > 0) {
      return 'You have started growing this week. Keep going.';
    }

    return 'Your next action can start this week’s growth.';
  }

  _GrowthStageData _growthStage(
    int points,
  ) {
    if (points >= 60) {
      return const _GrowthStageData(
        level: 5,
        name: 'Thriving Tree',
        description:
            'Your habits have grown into a strong and thriving tree.',
        icon: Icons.park_rounded,
        progress: 1,
        nextStageName: 'Thriving Tree',
        pointsRemaining: 0,
        isMaxLevel: true,
      );
    }

    if (points >= 30) {
      return _GrowthStageData(
        level: 4,
        name: 'Growing Tree',
        description:
            'Your consistent actions are becoming lasting growth.',
        icon: Icons.park_outlined,
        progress:
            ((points - 30) / 30).clamp(
          0.0,
          1.0,
        ),
        nextStageName: 'Thriving Tree',
        pointsRemaining: 60 - points,
        isMaxLevel: false,
      );
    }

    if (points >= 15) {
      return _GrowthStageData(
        level: 3,
        name: 'Young Tree',
        description:
            'Your progress is becoming visible and stronger.',
        icon: Icons.eco_rounded,
        progress:
            ((points - 15) / 15).clamp(
          0.0,
          1.0,
        ),
        nextStageName: 'Growing Tree',
        pointsRemaining: 30 - points,
        isMaxLevel: false,
      );
    }

    if (points >= 5) {
      return _GrowthStageData(
        level: 2,
        name: 'Sprout',
        description:
            'Your small actions are beginning to take root.',
        icon: Icons.spa_rounded,
        progress:
            ((points - 5) / 10).clamp(
          0.0,
          1.0,
        ),
        nextStageName: 'Young Tree',
        pointsRemaining: 15 - points,
        isMaxLevel: false,
      );
    }

    return _GrowthStageData(
      level: 1,
      name: 'Seed',
      description:
          'Every meaningful record helps your future begin to grow.',
      icon: Icons.grass_rounded,
      progress:
          (points / 5).clamp(
        0.0,
        1.0,
      ),
      nextStageName: 'Sprout',
      pointsRemaining: 5 - points,
      isMaxLevel: false,
    );
  }

  bool _sameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String _weekdayShort(
    int weekday,
  ) {
    const values = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return values[weekday - 1];
  }

  String _formatRecordDate(
    DateTime date,
  ) {
    final now = DateTime.now();

    if (_sameDate(
      date,
      now,
    )) {
      return 'Today • ${_formatTime(date)}';
    }

    final yesterday = now.subtract(
      const Duration(days: 1),
    );

    if (_sameDate(
      date,
      yesterday,
    )) {
      return 'Yesterday • ${_formatTime(date)}';
    }

    return '${date.month}/${date.day} • ${_formatTime(date)}';
  }

  String _formatTime(
    DateTime date,
  ) {
    final hour = date.hour;

    final minute =
        date.minute.toString().padLeft(
              2,
              '0',
            );

    final period =
        hour >= 12 ? 'PM' : 'AM';

    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    return '$displayHour:$minute $period';
  }

  _CategoryVisual _categoryVisual(
    RecordCategory category,
  ) {
    switch (category) {
      case RecordCategory.mood:
        return const _CategoryVisual(
          icon:
              Icons.sentiment_satisfied_alt_rounded,
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
          icon:
              Icons.account_balance_wallet_outlined,
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
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
    );
  }
}

class _TreeMetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _TreeMetricCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: GrowthPage.lightGreen,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7A8C84),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: GrowthPage.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthStageData {
  final int level;
  final String name;
  final String description;
  final IconData icon;
  final double progress;
  final String nextStageName;
  final int pointsRemaining;
  final bool isMaxLevel;

  const _GrowthStageData({
    required this.level,
    required this.name,
    required this.description,
    required this.icon,
    required this.progress,
    required this.nextStageName,
    required this.pointsRemaining,
    required this.isMaxLevel,
  });
}

class _DayGrowth {
  final String label;
  final int points;
  final bool isToday;

  const _DayGrowth({
    required this.label,
    required this.points,
    required this.isToday,
  });
}

class _CategoryContribution {
  final String label;
  final int points;
  final IconData icon;
  final Color color;

  const _CategoryContribution({
    required this.label,
    required this.points,
    required this.icon,
    required this.color,
  });
}

class _CategoryVisual {
  final IconData icon;
  final Color color;

  const _CategoryVisual({
    required this.icon,
    required this.color,
  });
}