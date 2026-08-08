import '../database/record_repository.dart';
import '../models/record_model.dart';

class MemoryService {
  const MemoryService._();

  static const MemoryService instance = MemoryService._();

  List<RecordModel> getAllMemories() {
    final records = RecordRepository.instance.getAll();

    final memories = records
        .where(
          (record) =>
              record.category == RecordCategory.memory,
        )
        .toList()
      ..sort(
        (a, b) => b.createdAt.compareTo(
          a.createdAt,
        ),
      );

    return memories;
  }

  List<RecordModel> getRecentMemories({
    int limit = 5,
  }) {
    if (limit <= 0) {
      return [];
    }

    final memories = getAllMemories();

    if (memories.length <= limit) {
      return memories;
    }

    return memories.take(limit).toList();
  }

  List<RecordModel> getMemoriesForDate(
    DateTime date,
  ) {
    return getAllMemories().where(
      (memory) {
        return _sameDate(
          memory.createdAt,
          date,
        );
      },
    ).toList();
  }

  List<RecordModel> getMemoriesInMonth(
    int year,
    int month,
  ) {
    return getAllMemories().where(
      (memory) {
        return memory.createdAt.year == year &&
            memory.createdAt.month == month;
      },
    ).toList();
  }

  List<RecordModel> getMemoriesInYear(
    int year,
  ) {
    return getAllMemories().where(
      (memory) {
        return memory.createdAt.year == year;
      },
    ).toList();
  }

  List<RecordModel> searchMemories(
    String query,
  ) {
    final normalizedQuery =
        query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return getAllMemories();
    }

    return getAllMemories().where(
      (memory) {
        final title =
            memory.title.toLowerCase();

        final description =
            memory.description.toLowerCase();

        return title.contains(
              normalizedQuery,
            ) ||
            description.contains(
              normalizedQuery,
            );
      },
    ).toList();
  }

  Map<DateTime, List<RecordModel>>
      groupMemoriesByDate() {
    final grouped =
        <DateTime, List<RecordModel>>{};

    for (final memory in getAllMemories()) {
      final date = _dateOnly(
        memory.createdAt,
      );

      grouped.putIfAbsent(
        date,
        () => [],
      );

      grouped[date]!.add(
        memory,
      );
    }

    return grouped;
  }

  Map<int, List<RecordModel>>
      groupMemoriesByYear() {
    final grouped =
        <int, List<RecordModel>>{};

    for (final memory in getAllMemories()) {
      final year = memory.createdAt.year;

      grouped.putIfAbsent(
        year,
        () => [],
      );

      grouped[year]!.add(
        memory,
      );
    }

    return grouped;
  }

  Map<String, List<RecordModel>>
      groupMemoriesByPeriod() {
    final now = DateTime.now();

    final today = _dateOnly(
      now,
    );

    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    final sevenDaysAgo = today.subtract(
      const Duration(days: 6),
    );

    final result =
        <String, List<RecordModel>>{};

    for (final memory in getAllMemories()) {
      final date = _dateOnly(
        memory.createdAt,
      );

      String section;

      if (_sameDate(
        date,
        today,
      )) {
        section = 'Today';
      } else if (_sameDate(
        date,
        yesterday,
      )) {
        section = 'Yesterday';
      } else if (!date.isBefore(
        sevenDaysAgo,
      )) {
        section = 'Last 7 Days';
      } else if (date.year == now.year &&
          date.month == now.month) {
        section = 'This Month';
      } else if (date.year == now.year) {
        section = '${date.year}';
      } else {
        section = '${date.year}';
      }

      result.putIfAbsent(
        section,
        () => [],
      );

      result[section]!.add(
        memory,
      );
    }

    return result;
  }

  int get totalMemories {
    return getAllMemories().length;
  }

  int get memoriesThisMonth {
    final now = DateTime.now();

    return getMemoriesInMonth(
      now.year,
      now.month,
    ).length;
  }

  int get memoriesThisYear {
    final now = DateTime.now();

    return getMemoriesInYear(
      now.year,
    ).length;
  }

  String buildMemorySummary() {
    final memories = getAllMemories();

    if (memories.isEmpty) {
      return 'Your memory journey is ready. Save a meaningful moment to begin preserving your story.';
    }

    final recent = getRecentMemories(
      limit: 7,
    );

    final activeDates = recent
        .map(
          (memory) => _dateOnly(
            memory.createdAt,
          ),
        )
        .toSet()
        .length;

    if (memories.length == 1) {
      return 'You have saved your first memory. Small moments can become meaningful parts of your story over time.';
    }

    if (activeDates >= 5) {
      return 'You have been preserving moments consistently. Your recent memories span $activeDates different days.';
    }

    if (memoriesThisMonth >= 5) {
      return 'You have saved $memoriesThisMonth memories this month. Your story is becoming richer with every meaningful moment.';
    }

    return 'You have preserved ${memories.length} memories so far. Keep capturing the moments you may want to remember later.';
  }

  List<RecordModel> getFavoriteMemories() {
    // Favorite support will be added when
    // the RecordModel gains a favorite field.
    return [];
  }

  bool isFavorite(
    RecordModel memory,
  ) {
    // Placeholder for Memory V2.
    return false;
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

  bool _sameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}