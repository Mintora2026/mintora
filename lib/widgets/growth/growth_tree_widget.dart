import 'package:flutter/material.dart';

import '../../models/growth_model.dart';

class GrowthTreeWidget extends StatelessWidget {
  const GrowthTreeWidget({
    super.key,
    required this.growth,
  });

  final GrowthModel growth;

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color lightGreen = Color(0xFFEAF7EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFE5EEE8),
        ),
      ),
      child: Column(
        children: [
          _buildSeasonBadge(),

          const SizedBox(height: 18),

          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 210,
                height: 210,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  shape: BoxShape.circle,
                ),
              ),

              Icon(
                growth.fallbackIcon,
                size: 118,
                color: mintGreen,
              ),

              Positioned(
                right: 18,
                bottom: 16,
                child: _buildMintPlaceholder(),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Text(
            growth.stageName,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            _stageDescription(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6D8078),
              fontSize: 14,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 24),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: growth.progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFEAF2ED),
              valueColor: const AlwaysStoppedAnimation(
                mintGreen,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '${(growth.progress * 100).round()}% to next stage',
            style: const TextStyle(
              color: Color(0xFF6D8078),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: 'Today',
                  value: '+${growth.todayGrowth}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Metric(
                  title: 'Week',
                  value: '${growth.weeklyGrowth}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Metric(
                  title: 'Total',
                  value:
                      '${growth.totalGrowthPoints}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        growth.seasonName,
        style: const TextStyle(
          color: darkGreen,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildMintPlaceholder() {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EEE8),
        ),
      ),
      child: const Icon(
        Icons.pets,
        color: mintGreen,
      ),
    );
  }

  String _stageDescription() {
    switch (growth.stage) {
      case GrowthStage.seed:
        return 'Every meaningful record begins your life tree.';

      case GrowthStage.sprout:
        return 'Your first habits are beginning to grow.';

      case GrowthStage.seedling:
        return 'Your tree is becoming stronger every day.';

      case GrowthStage.youngTree:
        return 'Your life is growing in many directions.';

      case GrowthStage.growingTree:
        return 'Consistency is turning into lasting growth.';

      case GrowthStage.bloomingTree:
        return 'Your efforts are beginning to bloom beautifully.';

      case GrowthStage.flourishingTree:
        return 'Your life tree is thriving and flourishing.';
    }
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color lightGreen = Color(0xFFEAF7EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6D8078),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}