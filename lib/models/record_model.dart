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

  const RecordModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.createdAt,
    this.growthPoints = 1,
    this.isCompleted = true,
  });

  RecordModel copyWith({
    String? id,
    RecordCategory? category,
    String? title,
    String? description,
    DateTime? createdAt,
    int? growthPoints,
    bool? isCompleted,
  }) {
    return RecordModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      growthPoints: growthPoints ?? this.growthPoints,
      isCompleted: isCompleted ?? this.isCompleted,
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
    };
  }

  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      id: map['id'] as String,
      category: RecordCategory.values.firstWhere(
        (category) => category.name == map['category'],
        orElse: () => RecordCategory.other,
      ),
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      growthPoints: map['growthPoints'] as int? ?? 1,
      isCompleted: map['isCompleted'] as bool? ?? true,
    );
  }
}