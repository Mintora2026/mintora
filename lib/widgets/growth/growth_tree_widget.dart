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
  static const Color softBorder = Color(0xFFE5EEE8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Column(
        children: [
          _buildSeasonBadge(),

          const SizedBox(height: 18),

          _buildTreeScene(),

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
              backgroundColor: const Color(
                0xFFEAF2ED,
              ),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                mintGreen,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            _progressText(),
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

  Widget _buildTreeScene() {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              color: _seasonBackgroundColor(),
              shape: BoxShape.circle,
            ),
          ),

          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                _treeAssetPath,
                fit: BoxFit.contain,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return _buildFallbackTree();
                },
              ),
            ),
          ),

          Positioned(
            right: 5,
            bottom: 16,
            child: _buildMint(),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackTree() {
    return Center(
      child: Icon(
        growth.fallbackIcon,
        size: 118,
        color: _treeFallbackColor(),
      ),
    );
  }

  Widget _buildSeasonBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: _seasonBadgeColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _seasonIcon(),
            size: 15,
            color: darkGreen,
          ),
          const SizedBox(width: 6),
          Text(
            growth.seasonName,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMint() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: softBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 8,
            offset: const Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      child: Image.asset(
        'assets/mascot/mint_idle.png',
        fit: BoxFit.contain,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return const Icon(
            Icons.eco_rounded,
            color: mintGreen,
            size: 27,
          );
        },
      ),
    );
  }

  String get _treeAssetPath {
    return 'assets/tree/${_seasonFolder()}/${_stageFileName()}.png';
  }

  String _seasonFolder() {
    switch (growth.season) {
      case TreeSeason.spring:
        return 'spring';

      case TreeSeason.summer:
        return 'summer';

      case TreeSeason.autumn:
        return 'autumn';

      case TreeSeason.winter:
        return 'winter';
    }
  }

  String _stageFileName() {
    switch (growth.stage) {
      case GrowthStage.seed:
        return 'seed';

      case GrowthStage.sprout:
        return 'sprout';

      case GrowthStage.seedling:
        return 'seedling';

      case GrowthStage.youngTree:
        return 'young_tree';

      case GrowthStage.growingTree:
        return 'growing_tree';

      case GrowthStage.bloomingTree:
        return 'blooming_tree';

      case GrowthStage.flourishingTree:
        return 'flourishing_tree';
    }
  }

  Color _seasonBackgroundColor() {
    switch (growth.season) {
      case TreeSeason.spring:
        return const Color(
          0xFFF0F8E9,
        );

      case TreeSeason.summer:
        return const Color(
          0xFFE6F6EC,
        );

      case TreeSeason.autumn:
        return const Color(
          0xFFFFF3E1,
        );

      case TreeSeason.winter:
        return const Color(
          0xFFF0F5F4,
        );
    }
  }

  Color _seasonBadgeColor() {
    switch (growth.season) {
      case TreeSeason.spring:
        return const Color(
          0xFFEDF8E6,
        );

      case TreeSeason.summer:
        return const Color(
          0xFFE7F6ED,
        );

      case TreeSeason.autumn:
        return const Color(
          0xFFFFF0D7,
        );

      case TreeSeason.winter:
        return const Color(
          0xFFEAF1F0,
        );
    }
  }

  Color _treeFallbackColor() {
    switch (growth.season) {
      case TreeSeason.spring:
        return const Color(
          0xFF82C96C,
        );

      case TreeSeason.summer:
        return mintGreen;

      case TreeSeason.autumn:
        return const Color(
          0xFFDFA454,
        );

      case TreeSeason.winter:
        return const Color(
          0xFF76958B,
        );
    }
  }

  IconData _seasonIcon() {
    switch (growth.season) {
      case TreeSeason.spring:
        return Icons.local_florist_rounded;

      case TreeSeason.summer:
        return Icons.wb_sunny_outlined;

      case TreeSeason.autumn:
        return Icons.eco_outlined;

      case TreeSeason.winter:
        return Icons.ac_unit_rounded;
    }
  }

  String _progressText() {
    if (growth.stage ==
        GrowthStage.flourishingTree) {
      return 'Your life tree is flourishing.';
    }

    return '${(growth.progress * 100).round()}% to next stage';
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

  static const Color darkGreen =
      Color(0xFF174C3C);

  static const Color lightGreen =
      Color(0xFFEAF7EF);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius:
            BorderRadius.circular(18),
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
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}