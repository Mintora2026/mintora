import 'package:flutter/material.dart';

/// Tree growth stage
enum GrowthStage {
  seed,
  sprout,
  seedling,
  youngTree,
  growingTree,
  bloomingTree,
  flourishingTree,
}

/// Tree season
enum TreeSeason {
  spring,
  summer,
  autumn,
  winter,
}

class GrowthModel {
  final int totalGrowthPoints;

  final int todayGrowth;

  final int weeklyGrowth;

  final int streakDays;

  final int activeDays;

  final double progress;

  final GrowthStage stage;

  final TreeSeason season;

  const GrowthModel({
    required this.totalGrowthPoints,
    required this.todayGrowth,
    required this.weeklyGrowth,
    required this.streakDays,
    required this.activeDays,
    required this.progress,
    required this.stage,
    required this.season,
  });

  bool get isBlooming =>
      stage.index >= GrowthStage.bloomingTree.index;

  bool get isMature =>
      stage.index >= GrowthStage.growingTree.index;

  String get stageName {
    switch (stage) {
      case GrowthStage.seed:
        return 'Seed';

      case GrowthStage.sprout:
        return 'Sprout';

      case GrowthStage.seedling:
        return 'Seedling';

      case GrowthStage.youngTree:
        return 'Young Tree';

      case GrowthStage.growingTree:
        return 'Growing Tree';

      case GrowthStage.bloomingTree:
        return 'Blooming Tree';

      case GrowthStage.flourishingTree:
        return 'Flourishing Tree';
    }
  }

  String get seasonName {
    switch (season) {
      case TreeSeason.spring:
        return 'Spring';

      case TreeSeason.summer:
        return 'Summer';

      case TreeSeason.autumn:
        return 'Autumn';

      case TreeSeason.winter:
        return 'Winter';
    }
  }

  IconData get fallbackIcon {
    switch (stage) {
      case GrowthStage.seed:
        return Icons.grass_rounded;

      case GrowthStage.sprout:
        return Icons.spa_rounded;

      case GrowthStage.seedling:
        return Icons.eco_rounded;

      case GrowthStage.youngTree:
        return Icons.park_outlined;

      case GrowthStage.growingTree:
      case GrowthStage.bloomingTree:
      case GrowthStage.flourishingTree:
        return Icons.park_rounded;
    }
  }
}