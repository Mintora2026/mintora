import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../services/insight_service.dart';
import '../widgets/ai_insight_card.dart';
import 'exercise_page.dart';
import 'finance_page.dart';
import 'health_page.dart';
import 'mood_page.dart';
import 'sleep_page.dart';
import 'study_page.dart';
import 'water_page.dart';
import 'work_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color mintGreen = Color(0xFF67C78F);
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color lightGreen = Color(0xFFE7F6ED);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE6EFE9);

  static const int dailyActivityGoal = 7;

  @override
  Widget build(BuildContext context) {
    final repository = RecordRepository.instance;
    final insightService = InsightService.instance;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        title: const Text(
          'Mintora',
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
                    'Notifications will be added later.',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
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
            final allRecords = [...repository.getAll()]
              ..sort(
                (a, b) => b.createdAt.compareTo(
                  a.createdAt,
                ),
              );

            final todayRecords = _getTodayRecords(
              allRecords,
            );

            final dashboard = _buildDashboardData(
              todayRecords,
            );

            final completedActivities =
                todayRecords.length;

            final todayGrowthPoints =
                insightService.calculateGrowthPoints(
              todayRecords,
            );

            final totalGrowthPoints =
                insightService.calculateGrowthPoints(
              allRecords,
            );

            final weeklyGrowthPoints =
                insightService.calculateGrowthPoints(
              allRecords,
              days: 7,
            );

            final activeDays =
                insightService.calculateActiveDays(
              allRecords,
              days: 7,
            );

            final currentStreak =
                insightService.calculateCurrentStreak(
              allRecords,
            );

            final dailyProgress =
                (completedActivities / dailyActivityGoal)
                    .clamp(
              0.0,
              1.0,
            );

            final dailyPercentage =
                (dailyProgress * 100).round();

            final growthStage = _growthStage(
              totalGrowthPoints,
            );

            final insight =
                insightService.buildTimelineInsight(
              allRecords,
            );

            final recentRecords =
                allRecords.take(3).toList();

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
                  _buildGreeting(),

                  const SizedBox(height: 22),

                  _buildGrowthCard(
                    completedActivities:
                        completedActivities,
                    percentage:
                        dailyPercentage,
                    progress:
                        dailyProgress,
                    growthPoints:
                        todayGrowthPoints,
                  ),

                  const SizedBox(height: 16),

                  _buildWeeklyOverview(
                    streak: currentStreak,
                    activeDays: activeDays,
                    weeklyGrowth:
                        weeklyGrowthPoints,
                  ),

                  const SizedBox(height: 28),

                  AiInsightCard(
                    title: 'Today’s Insight',
                    message: insight,
                  ),

                  const SizedBox(height: 30),

                  _buildSectionHeader(
                    title: "Today's Snapshot",
                    subtitle:
                        'A quick look at your day.',
                  ),

                  const SizedBox(height: 14),

                  _buildSnapshotGrid(
                    dashboard,
                  ),

                  const SizedBox(height: 30),

                  _buildSectionHeader(
                    title: 'Quick Record',
                    subtitle:
                        'Capture something in a few seconds.',
                  ),

                  const SizedBox(height: 14),

                  _buildQuickRecordGrid(
                    context,
                  ),

                  const SizedBox(height: 30),

                  _buildSectionHeader(
                    title: 'Your Growth Tree',
                    subtitle:
                        'Your progress continues across days, weeks, and months.',
                  ),

                  const SizedBox(height: 14),

                  _buildGrowthTreeCard(
                    stage: growthStage,
                    todayGrowthPoints:
                        todayGrowthPoints,
                    totalGrowthPoints:
                        totalGrowthPoints,
                  ),

                  const SizedBox(height: 30),

                  _buildSectionHeader(
                    title: 'Recent Activity',
                    subtitle:
                        'Your latest moments and progress.',
                  ),

                  const SizedBox(height: 14),

                  _buildRecentActivityCard(
                    recentRecords,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<RecordModel> _getTodayRecords(
    List<RecordModel> records,
  ) {
    final now = DateTime.now();

    return records.where((record) {
      final date = record.createdAt;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();
  }

  _DashboardData _buildDashboardData(
    List<RecordModel> records,
  ) {
    var moodCount = 0;
    var exerciseCount = 0;
    var healthCount = 0;

    var waterMl = 0;
    var workMinutes = 0;
    var studyMinutes = 0;

    var financeIncome = 0.0;
    var financeExpense = 0.0;

    String? sleepDuration;

    final sortedRecords = [...records]
      ..sort(
        (a, b) => b.createdAt.compareTo(
          a.createdAt,
        ),
      );

    for (final record in sortedRecords) {
      switch (record.category) {
        case RecordCategory.mood:
          moodCount++;

        case RecordCategory.sleep:
          sleepDuration ??= _extractValue(
            record.description,
            'Duration:',
          );

        case RecordCategory.work:
          workMinutes +=
              _extractDurationMinutes(
            record.description,
            'Duration:',
          );

        case RecordCategory.study:
          studyMinutes +=
              _extractDurationMinutes(
            record.description,
            'Study time:',
          );

        case RecordCategory.finance:
          final amount = _extractFinanceAmount(
            record.description,
          );

          if (record.description.contains(
            'Type: Income',
          )) {
            financeIncome += amount;
          } else if (record.description.contains(
            'Type: Expense',
          )) {
            financeExpense += amount;
          }

        case RecordCategory.health:
          healthCount++;

        case RecordCategory.exercise:
          exerciseCount++;

        case RecordCategory.water:
          waterMl += _extractWaterMl(
            record.description,
          );

        case RecordCategory.memory:
        case RecordCategory.other:
          break;
      }
    }

    return _DashboardData(
      moodCount: moodCount,
      sleepDuration: sleepDuration ?? '--',
      waterMl: waterMl,
      exerciseCount: exerciseCount,
      workMinutes: workMinutes,
      studyMinutes: studyMinutes,
      financeIncome: financeIncome,
      financeExpense: financeExpense,
      healthCount: healthCount,
    );
  }

  String? _extractValue(
    String description,
    String prefix,
  ) {
    final lines = description.split('\n');

    for (final line in lines) {
      if (line.startsWith(prefix)) {
        return line
            .substring(prefix.length)
            .trim();
      }
    }

    return null;
  }

  int _extractWaterMl(
    String description,
  ) {
    final regex = RegExp(
      r'Water:\s*(\d+)\s*ml',
    );

    final match = regex.firstMatch(
      description,
    );

    if (match == null) {
      return 0;
    }

    return int.tryParse(
          match.group(1) ?? '',
        ) ??
        0;
  }

  double _extractFinanceAmount(
    String description,
  ) {
    final regex = RegExp(
      r'Amount:\s*\$?([0-9]+(?:\.[0-9]+)?)',
    );

    final match = regex.firstMatch(
      description,
    );

    if (match == null) {
      return 0;
    }

    return double.tryParse(
          match.group(1) ?? '',
        ) ??
        0;
  }

  int _extractDurationMinutes(
    String description,
    String prefix,
  ) {
    final value = _extractValue(
      description,
      prefix,
    );

    if (value == null) {
      return 0;
    }

    var minutes = 0;

    final hoursMatch = RegExp(
      r'(\d+)\s*h',
    ).firstMatch(
      value,
    );

    final minutesMatch = RegExp(
      r'(\d+)\s*min',
    ).firstMatch(
      value,
    );

    if (hoursMatch != null) {
      minutes +=
          (int.tryParse(
                    hoursMatch.group(1) ?? '',
                  ) ??
                  0) *
              60;
    }

    if (minutesMatch != null) {
      minutes += int.tryParse(
            minutesMatch.group(1) ?? '',
          ) ??
          0;
    }

    return minutes;
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;

    final greeting = hour < 12
        ? 'Good morning'
        : hour < 18
            ? 'Good afternoon'
            : 'Good evening';

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
            fontSize: 26,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Today's Growth",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            completedActivities == 1
                ? '1 activity • $growthPoints growth point'
                : '$completedActivities activities • $growthPoints growth points',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor:
                  Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Color(0xFF9EE76B),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            completedActivities >=
                    dailyActivityGoal
                ? 'Daily activity goal reached.'
                : '${dailyActivityGoal - completedActivities} more to reach today’s activity goal.',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyOverview({
    required int streak,
    required int activeDays,
    required int weeklyGrowth,
  }) {
    return Row(
      children: [
        Expanded(
          child: _MiniStatCard(
            icon: Icons.local_fire_department_rounded,
            value: '$streak',
            label: 'Streak',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniStatCard(
            icon: Icons.calendar_today_outlined,
            value: '$activeDays',
            label: 'Active Days',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniStatCard(
            icon: Icons.auto_awesome_rounded,
            value: '$weeklyGrowth',
            label: 'Week Points',
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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

  Widget _buildSnapshotGrid(
    _DashboardData data,
  ) {
    final cards = [
      _SnapshotItem(
        title: 'Mood',
        value: data.moodCount == 0
            ? '--'
            : '${data.moodCount}',
        subtitle: data.moodCount == 1
            ? 'check-in'
            : 'check-ins',
        icon: Icons.sentiment_satisfied_alt_rounded,
        color: const Color(0xFFFFB85C),
      ),
      _SnapshotItem(
        title: 'Sleep',
        value: data.sleepDuration,
        subtitle: 'last sleep',
        icon: Icons.bedtime_outlined,
        color: const Color(0xFF7A91E8),
      ),
      _SnapshotItem(
        title: 'Water',
        value: data.waterMl == 0
            ? '--'
            : '${data.waterMl} ml',
        subtitle: 'today',
        icon: Icons.water_drop_outlined,
        color: const Color(0xFF62B8F6),
      ),
      _SnapshotItem(
        title: 'Exercise',
        value: '${data.exerciseCount}',
        subtitle: data.exerciseCount == 1
            ? 'session'
            : 'sessions',
        icon: Icons.directions_run_rounded,
        color: const Color(0xFFFF9F68),
      ),
      _SnapshotItem(
        title: 'Work',
        value: _formatMinutes(
          data.workMinutes,
        ),
        subtitle: 'focused time',
        icon: Icons.work_outline_rounded,
        color: const Color(0xFF70A8F5),
      ),
      _SnapshotItem(
        title: 'Study',
        value: _formatMinutes(
          data.studyMinutes,
        ),
        subtitle: 'learning time',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFFA78BF0),
      ),
      _SnapshotItem(
        title: 'Spent',
        value:
            '\$${data.financeExpense.toStringAsFixed(2)}',
        subtitle: 'today',
        icon: Icons.arrow_upward_rounded,
        color: const Color(0xFFE78572),
      ),
      _SnapshotItem(
        title: 'Income',
        value:
            '\$${data.financeIncome.toStringAsFixed(2)}',
        subtitle: 'today',
        icon: Icons.arrow_downward_rounded,
        color: const Color(0xFF64CFA1),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.65,
      ),
      itemBuilder: (
        context,
        index,
      ) {
        final item = cards[index];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color: softBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.color.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color:
                            Color(0xFF7A8C84),
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.value,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        color:
                            Color(0xFF9AA6A1),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickRecordGrid(
    BuildContext context,
  ) {
    final items = [
      const _QuickRecordItem(
        category: RecordCategory.mood,
        icon: Icons.sentiment_satisfied_alt_rounded,
        label: 'Mood',
        color: Color(0xFFFFC96B),
      ),
      const _QuickRecordItem(
        category: RecordCategory.sleep,
        icon: Icons.bedtime_outlined,
        label: 'Sleep',
        color: Color(0xFF7A91E8),
      ),
      const _QuickRecordItem(
        category: RecordCategory.work,
        icon: Icons.work_outline_rounded,
        label: 'Work',
        color: Color(0xFF70A8F5),
      ),
      const _QuickRecordItem(
        category: RecordCategory.study,
        icon: Icons.menu_book_rounded,
        label: 'Study',
        color: Color(0xFFA78BF0),
      ),
      const _QuickRecordItem(
        category: RecordCategory.finance,
        icon: Icons.account_balance_wallet_outlined,
        label: 'Finance',
        color: Color(0xFF64CFA1),
      ),
      const _QuickRecordItem(
        category: RecordCategory.health,
        icon: Icons.favorite_border_rounded,
        label: 'Health',
        color: Color(0xFFFF8A8A),
      ),
      const _QuickRecordItem(
        category: RecordCategory.exercise,
        icon: Icons.directions_run_rounded,
        label: 'Exercise',
        color: Color(0xFFFF9F68),
      ),
      const _QuickRecordItem(
        category: RecordCategory.water,
        icon: Icons.water_drop_outlined,
        label: 'Water',
        color: Color(0xFF62B8F6),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (
        context,
        index,
      ) {
        final item = items[index];

        return InkWell(
          onTap: () {
            _openQuickRecord(
              context,
              item.category,
            );
          },
          borderRadius:
              BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color: softBorder,
              ),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.color.withValues(
                      alpha: 0.14,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 23,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.label,
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openQuickRecord(
    BuildContext context,
    RecordCategory category,
  ) {
    Widget page;

    switch (category) {
      case RecordCategory.mood:
        page = const MoodPage();

      case RecordCategory.sleep:
        page = const SleepPage();

      case RecordCategory.work:
        page = const WorkPage();

      case RecordCategory.study:
        page = const StudyPage();

      case RecordCategory.finance:
        page = const FinancePage();

      case RecordCategory.health:
        page = const HealthPage();

      case RecordCategory.exercise:
        page = const ExercisePage();

      case RecordCategory.water:
        page = const WaterPage();

      case RecordCategory.memory:
      case RecordCategory.other:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  Widget _buildGrowthTreeCard({
    required _GrowthStageData stage,
    required int todayGrowthPoints,
    required int totalGrowthPoints,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius:
            BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  stage.icon,
                  color: mintGreen,
                  size: 60,
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                      child: Text(
                        'Level ${stage.level}',
                        style: const TextStyle(
                          color: darkGreen,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      stage.name,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      stage.description,
                      style: const TextStyle(
                        color:
                            Color(0xFF557268),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildGrowthStat(
                  label: 'Today',
                  value:
                      '+$todayGrowthPoints',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildGrowthStat(
                  label: 'Total Growth',
                  value:
                      '$totalGrowthPoints',
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
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${(stage.progress * 100).round()}%',
                style: const TextStyle(
                  color: mintGreen,
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: stage.progress,
              minHeight: 10,
              backgroundColor:
                  Colors.white,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                mintGreen,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            stage.isMaxLevel
                ? 'Keep recording your journey and growing your life story.'
                : '${stage.pointsRemaining} growth points until ${stage.nextStageName}.',
            style: const TextStyle(
              color: Color(0xFF6A8077),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthStat({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
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
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(
    List<RecordModel> records,
  ) {
    if (records.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 34,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(22),
          border: Border.all(
            color: softBorder,
          ),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.history_rounded,
              color: mintGreen,
              size: 38,
            ),
            SizedBox(height: 12),
            Text(
              'No activity yet',
              style: TextStyle(
                color: darkGreen,
                fontSize: 17,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Your latest records will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B7D75),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
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
                  padding:
                      const EdgeInsets.symmetric(
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
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
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
                                color:
                                    Color(0xFF85958E),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Text(
                          '+${record.growthPoints}',
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 11,
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

  _CategoryVisual _categoryVisual(
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

  bool _sameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
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

  String _formatMinutes(
    int minutes,
  ) {
    if (minutes <= 0) {
      return '--';
    }

    if (minutes < 60) {
      return '$minutes min';
    }

    final hours = minutes ~/ 60;
    final remaining = minutes % 60;

    if (remaining == 0) {
      return '$hours h';
    }

    return '$hours h ${remaining}m';
  }
}

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: HomePage.softBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: HomePage.mintGreen,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: HomePage.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7A8C84),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardData {
  final int moodCount;
  final String sleepDuration;
  final int waterMl;
  final int exerciseCount;
  final int workMinutes;
  final int studyMinutes;
  final double financeIncome;
  final double financeExpense;
  final int healthCount;

  const _DashboardData({
    required this.moodCount,
    required this.sleepDuration,
    required this.waterMl,
    required this.exerciseCount,
    required this.workMinutes,
    required this.studyMinutes,
    required this.financeIncome,
    required this.financeExpense,
    required this.healthCount,
  });
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

class _SnapshotItem {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SnapshotItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _QuickRecordItem {
  final RecordCategory category;
  final IconData icon;
  final String label;
  final Color color;

  const _QuickRecordItem({
    required this.category,
    required this.icon,
    required this.label,
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