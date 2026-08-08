import 'package:flutter/material.dart';

import '../../database/record_repository.dart';
import '../../services/memory_service.dart';
import '../../widgets/memory/memory_card.dart';
import 'memory_detail_page.dart';

class FavoriteMemoryPage extends StatelessWidget {
  const FavoriteMemoryPage({super.key});

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
          'Favorite Memories',
          style: TextStyle(
            color: darkGreen,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, child) {
            final favorites =
                memoryService.getFavoriteMemories();

            if (favorites.isEmpty) {
              return const _EmptyFavorites();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                36,
              ),
              children: [
                const Text(
                  'The moments you chose to keep close.',
                  style: TextStyle(
                    color: Color(0xFF6B7D75),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Saved Favorites',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7EF),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: Text(
                        '${favorites.length}',
                        style: const TextStyle(
                          color: darkGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ...List.generate(
                  favorites.length,
                  (index) {
                    final memory = favorites[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            index == favorites.length - 1
                                ? 0
                                : 12,
                      ),
                      child: MemoryCard(
                        memory: memory,
                        isFavorite: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MemoryDetailPage(
                                memory: memory,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEEEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: Color(0xFFFF8A8A),
                size: 38,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No favorite memories yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: FavoriteMemoryPage.darkGreen,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mark special memories as favorites and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B7D75),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}