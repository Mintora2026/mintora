import '../models/record_model.dart';

class InsightService {
  const InsightService._();

  static const InsightService instance = InsightService._();

  String buildTimelineInsight(
    List<RecordModel> records,
  ) {
    final recentRecords = _recordsInLastDays(
      records,
      7,
    );

    if (recentRecords.isEmpty) {
      return 'Your timeline is ready. Add a record today to begin building your life story.';
    }

    final categoryCounts = <RecordCategory, int>{};
    final activeDates = <DateTime>{};

    for (final record in recentRecords) {
      categoryCounts.update(
        record.category,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      activeDates.add(
        _dateOnly(record.createdAt),
      );
    }

    RecordCategory? strongestCategory;
    var strongestCount = 0;

    for (final entry in categoryCounts.entries) {
      if (entry.value > strongestCount) {
        strongestCategory = entry.key;
        strongestCount = entry.value;
      }
    }

    final activeDays = activeDates.length;

    if (strongestCategory == null) {
      return 'You created ${recentRecords.length} records during the last 7 days.';
    }

    final strongestName = categoryName(
      strongestCategory,
    );

    if (activeDays >= 5) {
      return '$strongestName has been your most active area recently. You recorded activity on $activeDays of the last 7 days, showing strong consistency.';
    }

    if (activeDays >= 3) {
      return '$strongestName is currently your most active area. You have recorded activity on $activeDays of the last 7 days.';
    }

    return '$strongestName appears most often in your recent timeline. Keep recording across the week to build a clearer picture of your life.';
  }

  String buildGrowthInsight(
    List<RecordModel> records,
  ) {
    if (records.isEmpty) {
      return 'Start with one small record today. Your first action will plant the seed for your Growth Tree.';
    }

    final recentRecords = _recordsInLastDays(
      records,
      7,
    );

    final categoryPoints = <RecordCategory, int>{};

    for (final record in records) {
      if (record.category == RecordCategory.memory ||
          record.category == RecordCategory.other) {
        continue;
      }

      categoryPoints.update(
        record.category,
        (value) => value + record.growthPoints,
        ifAbsent: () => record.growthPoints,
      );
    }

    if (categoryPoints.isEmpty) {
      return 'Your Growth Tree has started. Keep recording meaningful actions to build a clearer picture of your progress.';
    }

    final sorted = categoryPoints.entries.toList()
      ..sort(
        (a, b) => b.value.compareTo(a.value),
      );

    final strongest = sorted.first;

    final activeDays = recentRecords
        .map(
          (record) => _dateOnly(
            record.createdAt,
          ),
        )
        .toSet()
        .length;

    final strongestName = categoryName(
      strongest.key,
    );

    if (activeDays >= 5) {
      return '$strongestName is currently your strongest growth area. You have also been active on $activeDays of the last 7 days, showing strong consistency.';
    }

    if (activeDays >= 3) {
      return '$strongestName is contributing the most to your growth. You were active on $activeDays of the last 7 days. One or two more active days would make your week more consistent.';
    }

    return '$strongestName is currently your strongest growth area. Try adding meaningful records across a few more days this week to build consistency.';
  }

  int calculateCurrentStreak(
    List<RecordModel> records,
  ) {
    if (records.isEmpty) {
      return 0;
    }

    final activeDates = records
        .map(
          (record) => _dateOnly(
            record.createdAt,
          ),
        )
        .toSet();

    final today = _dateOnly(
      DateTime.now(),
    );

    var currentDate = today;

    if (!activeDates.contains(currentDate)) {
      final yesterday = currentDate.subtract(
        const Duration(days: 1),
      );

      if (!activeDates.contains(yesterday)) {
        return 0;
      }

      currentDate = yesterday;
    }

    var streak = 0;

    while (activeDates.contains(currentDate)) {
      streak++;

      currentDate = currentDate.subtract(
        const Duration(days: 1),
      );
    }

    return streak;
  }

  int calculateActiveDays(
    List<RecordModel> records, {
    int days = 7,
  }) {
    return _recordsInLastDays(
      records,
      days,
    )
        .map(
          (record) => _dateOnly(
            record.createdAt,
          ),
        )
        .toSet()
        .length;
  }

  int calculateGrowthPoints(
    List<RecordModel> records, {
    int? days,
  }) {
    final selectedRecords = days == null
        ? records
        : _recordsInLastDays(
            records,
            days,
          );

    return selectedRecords.fold<int>(
      0,
      (sum, record) =>
          sum + record.growthPoints,
    );
  }

  Map<RecordCategory, int>
      calculateCategoryGrowth(
    List<RecordModel> records,
  ) {
    final result = <RecordCategory, int>{};

    for (final record in records) {
      result.update(
        record.category,
        (value) =>
            value + record.growthPoints,
        ifAbsent: () =>
            record.growthPoints,
      );
    }

    return result;
  }

  List<RecordModel> _recordsInLastDays(
    List<RecordModel> records,
    int days,
  ) {
    if (days <= 0) {
      return [];
    }

    final today = _dateOnly(
      DateTime.now(),
    );

    final startDate = today.subtract(
      Duration(
        days: days - 1,
      ),
    );

    return records.where(
      (record) {
        final recordDate = _dateOnly(
          record.createdAt,
        );

        return !recordDate.isBefore(
          startDate,
        );
      },
    ).toList();
  }

  DateTime _dateOnly(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  String categoryName(
    RecordCategory category,
  ) {
    switch (category) {
      case RecordCategory.mood:
        return 'Mood';

      case RecordCategory.sleep:
        return 'Sleep';

      case RecordCategory.work:
        return 'Work';

      case RecordCategory.study:
        return 'Study';

      case RecordCategory.finance:
        return 'Finance';

      case RecordCategory.health:
        return 'Health';

      case RecordCategory.exercise:
        return 'Exercise';

      case RecordCategory.water:
        return 'Water';

      case RecordCategory.memory:
        return 'Memory';

      case RecordCategory.other:
        return 'Other';
    }
  }
}