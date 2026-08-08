import 'dart:convert';

enum RecordCategory {
  mood,
  sleep,
  work,
  study,
  finance,
  health,
  exercise,
  water,
  memory,
  other,
}

class RecordModel {
  final String id;
  final RecordCategory category;
  final String title;
  final String description;
  final DateTime createdAt;
  final int growthPoints;
  final bool isCompleted;
  final bool isFavorite;
  final String? mediaPath;
  final String? location;
  final List<String> tags;

  const RecordModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.createdAt,
    this.growthPoints = 1,
    this.isCompleted = true,
    this.isFavorite = false,
    this.mediaPath,
    this.location,
    this.tags = const [],
  });

  RecordModel copyWith({
    String? id,
    RecordCategory? category,
    String? title,
    String? description,
    DateTime? createdAt,
    int? growthPoints,
    bool? isCompleted,
    bool? isFavorite,
    String? mediaPath,
    String? location,
    List<String>? tags,
  }) {
    return RecordModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      growthPoints: growthPoints ?? this.growthPoints,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
      mediaPath: mediaPath ?? this.mediaPath,
      location: location ?? this.location,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.name,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'growthPoints': growthPoints,
      'isCompleted': isCompleted,
      'isFavorite': isFavorite,
      'mediaPath': mediaPath,
      'location': location,
      'tags': jsonEncode(tags),
    };
  }

  factory RecordModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return RecordModel(
      id: map['id'] as String,
      category: RecordCategory.values.firstWhere(
        (category) =>
            category.name == map['category'],
        orElse: () => RecordCategory.other,
      ),
      title: map['title'] as String,
      description:
          map['description'] as String? ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] as String,
      ),
      growthPoints:
          map['growthPoints'] as int? ?? 1,
      isCompleted: _readBool(
        map['isCompleted'],
        defaultValue: true,
      ),
      isFavorite: _readBool(
        map['isFavorite'],
        defaultValue: false,
      ),
      mediaPath:
          map['mediaPath'] as String?,
      location:
          map['location'] as String?,
      tags: _readTags(
        map['tags'],
      ),
    );
  }

  static bool _readBool(
    dynamic value, {
    required bool defaultValue,
  }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    return defaultValue;
  }

  static List<String> _readTags(
    dynamic value,
  ) {
    if (value == null) {
      return const [];
    }

    if (value is List) {
      return value
          .map(
            (item) => item.toString().trim(),
          )
          .where(
            (item) => item.isNotEmpty,
          )
          .toList();
    }

    if (value is String) {
      final trimmed = value.trim();

      if (trimmed.isEmpty) {
        return const [];
      }

      try {
        final decoded = jsonDecode(
          trimmed,
        );

        if (decoded is List) {
          return decoded
              .map(
                (item) =>
                    item.toString().trim(),
              )
              .where(
                (item) => item.isNotEmpty,
              )
              .toList();
        }
      } catch (_) {
        return trimmed
            .split(',')
            .map(
              (item) => item.trim(),
            )
            .where(
              (item) => item.isNotEmpty,
            )
            .toList();
      }
    }

    return const [];
  }
}