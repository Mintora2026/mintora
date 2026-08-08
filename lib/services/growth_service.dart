import '../database/record_repository.dart';
import '../models/growth_model.dart';
import '../models/record_model.dart';

class GrowthService {
  GrowthService._();

  static final GrowthService instance =
      GrowthService._();

  GrowthModel buildGrowthModel() {
    final records = [
      ...RecordRepository.instance.getAll(),
    ];

    records.sort(
      (a, b) =>
          b.createdAt.compareTo(a.createdAt),
    );

    final totalGrowth =
        _calculateTotalGrowth(records);

    final todayGrowth =
        _calculateTodayGrowth(records);

    final weeklyGrowth =
        _calculateWeeklyGrowth(records);

    final streak =
        _calculateCurrentStreak(records);

    final activeDays =
        _calculateActiveDays(records);

    final stage =
        _calculateStage(totalGrowth);

    final progress =
        _calculateProgress(
      totalGrowth,
      stage,
    );

    final season =
        _currentSeason();

    return GrowthModel(
      totalGrowthPoints: totalGrowth,
      todayGrowth: todayGrowth,
      weeklyGrowth: weeklyGrowth,
      streakDays: streak,
      activeDays: activeDays,
      progress: progress,
      stage: stage,
      season: season,
    );
  }

  int _calculateTotalGrowth(
    List<RecordModel> records,
  ) {
    return records.fold(
      0,
      (sum, record) =>
          sum + record.growthPoints,
    );
  }

  int _calculateTodayGrowth(
    List<RecordModel> records,
  ) {
    final now = DateTime.now();

    return records
        .where(
          (record) =>
              _sameDate(
                record.createdAt,
                now,
              ),
        )
        .fold(
          0,
          (sum, record) =>
              sum + record.growthPoints,
        );
  }

  int _calculateWeeklyGrowth(
    List<RecordModel> records,
  ) {
    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(
      const Duration(days: 6),
    );

    return records
        .where(
          (record) =>
              !record.createdAt.isBefore(start),
        )
        .fold(
          0,
          (sum, record) =>
              sum + record.growthPoints,
        );
  }

  int _calculateActiveDays(
    List<RecordModel> records,
  ) {
    final now = DateTime.now();

    final dates = <String>{};

    for (final record in records) {
      if (now
              .difference(
                record.createdAt,
              )
              .inDays <=
          6) {
        dates.add(
          '${record.createdAt.year}-${record.createdAt.month}-${record.createdAt.day}',
        );
      }
    }

    return dates.length;
  }

  int _calculateCurrentStreak(
    List<RecordModel> records,
  ) {
    if (records.isEmpty) {
      return 0;
    }

    final days = <String>{};

    for (final record in records) {
      days.add(
        '${record.createdAt.year}-${record.createdAt.month}-${record.createdAt.day}',
      );
    }

    int streak = 0;

    var day = DateTime.now();

    while (true) {
      final key =
          '${day.year}-${day.month}-${day.day}';

      if (days.contains(key)) {
        streak++;
        day = day.subtract(
          const Duration(days: 1),
        );
      } else {
        break;
      }
    }

    return streak;
  }

  GrowthStage _calculateStage(
    int points,
  ) {
    if (points >= 300) {
      return GrowthStage.flourishingTree;
    }

    if (points >= 180) {
      return GrowthStage.bloomingTree;
    }

    if (points >= 100) {
      return GrowthStage.growingTree;
    }

    if (points >= 50) {
      return GrowthStage.youngTree;
    }

    if (points >= 20) {
      return GrowthStage.seedling;
    }

    if (points >= 5) {
      return GrowthStage.sprout;
    }

    return GrowthStage.seed;
  }

  double _calculateProgress(
    int points,
    GrowthStage stage,
  ) {
    switch (stage) {
      case GrowthStage.seed:
        return (points / 5).clamp(
          0.0,
          1.0,
        );

      case GrowthStage.sprout:
        return ((points - 5) / 15)
            .clamp(
          0.0,
          1.0,
        );

      case GrowthStage.seedling:
        return ((points - 20) / 30)
            .clamp(
          0.0,
          1.0,
        );

      case GrowthStage.youngTree:
        return ((points - 50) / 50)
            .clamp(
          0.0,
          1.0,
        );

      case GrowthStage.growingTree:
        return ((points - 100) / 80)
            .clamp(
          0.0,
          1.0,
        );

      case GrowthStage.bloomingTree:
        return ((points - 180) / 120)
            .clamp(
          0.0,
          1.0,
        );

      case GrowthStage.flourishingTree:
        return 1.0;
    }
  }

  TreeSeason _currentSeason() {
    final month = DateTime.now().month;

    if (month >= 3 && month <= 5) {
      return TreeSeason.spring;
    }

    if (month >= 6 && month <= 8) {
      return TreeSeason.summer;
    }

    if (month >= 9 && month <= 11) {
      return TreeSeason.autumn;
    }

    return TreeSeason.winter;
  }

  bool _sameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}