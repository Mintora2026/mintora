import 'package:flutter/material.dart';

import '../../database/record_repository.dart';
import '../../models/record_model.dart';
import '../../services/memory_service.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/memory/memory_card.dart';
import '../../widgets/memory/memory_header.dart';
import '../../widgets/memory/memory_section.dart';
import '../../widgets/memory/memory_timeline.dart';
import 'add_memory_page.dart';
import 'favorite_memory_page.dart';
import 'memory_detail_page.dart';
import 'memory_search_page.dart';

class MemoryPage extends StatelessWidget {
  const MemoryPage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  @override
  Widget build(BuildContext context) {
    final repository = RecordRepository.instance;
    final memoryService = MemoryService.instance;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Memory',
          style: TextStyle(
            color: darkGreen,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search memories',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MemorySearchPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.search_rounded,
              color: darkGreen,
            ),
          ),
          IconButton(
            tooltip: 'Favorite memories',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FavoriteMemoryPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite_border_rounded,
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
            final memories =
                memoryService.getAllMemories();

            final recentMemories =
                memoryService.getRecentMemories(
              limit: 3,
            );

            final groupedMemories =
                memoryService.groupMemoriesByDate();

            final summary =
                memoryService.buildMemorySummary();

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
                    'Preserve the moments that make your life meaningful.',
                    style: TextStyle(
                      color: Color(0xFF6B7F76),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 22),

                  MemoryHeader(
                    totalMemories:
                        memoryService.totalMemories,
                    thisMonth:
                        memoryService.memoriesThisMonth,
                    thisYear:
                        memoryService.memoriesThisYear,
                  ),

                  const SizedBox(height: 24),

                  AiInsightCard(
                    title: 'Memory Reflection',
                    message: summary,
                  ),

                  const SizedBox(height: 28),

                  _buildMemoryActions(
                    context,
                  ),

                  const SizedBox(height: 30),

                  MemorySection(
                    title: 'Recent Memories',
                    subtitle:
                        'Your latest moments worth remembering.',
                    count: recentMemories.length,
                    child: recentMemories.isEmpty
                        ? _buildRecentEmptyState()
                        : Column(
                            children: List.generate(
                              recentMemories.length,
                              (index) {
                                final memory =
                                    recentMemories[index];

                                return Padding(
                                  padding:
                                      EdgeInsets.only(
                                    bottom: index ==
                                            recentMemories.length - 1
                                        ? 0
                                        : 12,
                                  ),
                                  child: MemoryCard(
                                    memory: memory,
                                    isFavorite:
                                        memoryService
                                            .isFavorite(
                                      memory,
                                    ),
                                    onTap: () {
                                      _openMemory(
                                        context,
                                        memory,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                  ),

                  const SizedBox(height: 32),

                  MemorySection(
                    title: 'Your Memory Timeline',
                    subtitle: memories.isEmpty
                        ? 'Your saved memories will appear here over time.'
                        : 'Browse your story by the day it happened.',
                    count: memories.length,
                    child: MemoryTimeline(
                      groupedMemories:
                          groupedMemories,
                      onMemoryTap: (memory) {
                        _openMemory(
                          context,
                          memory,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AddMemoryPage(),
            ),
          );

          if (!context.mounted) {
            return;
          }

          if (saved == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Your new memory is now part of your story.',
                ),
              ),
            );
          }
        },
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Add Memory',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildMemoryActions(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: _MemoryActionCard(
            icon: Icons.search_rounded,
            title: 'Search',
            subtitle: 'Find a memory',
            color: const Color(0xFF70A8F5),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MemorySearchPage(),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _MemoryActionCard(
            icon: Icons.favorite_border_rounded,
            title: 'Favorites',
            subtitle: 'Moments you love',
            color: const Color(0xFFFF8A8A),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FavoriteMemoryPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 34,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.photo_album_outlined,
            color: mintGreen,
            size: 40,
          ),
          SizedBox(height: 12),
          Text(
            'No memories yet',
            style: TextStyle(
              color: darkGreen,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Save your first meaningful moment and begin building your life story.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _openMemory(
    BuildContext context,
    RecordModel memory,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MemoryDetailPage(
          memory: memory,
        ),
      ),
    );
  }
}

class _MemoryActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MemoryActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: MemoryPage.softBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: MemoryPage.darkGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF84948D),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: MemoryPage.mintGreen,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}