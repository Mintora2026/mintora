import 'package:flutter/material.dart';

import '../../models/record_model.dart';
import '../../services/memory_service.dart';
import '../../widgets/memory/memory_card.dart';
import 'memory_detail_page.dart';

class MemorySearchPage extends StatefulWidget {
  const MemorySearchPage({super.key});

  @override
  State<MemorySearchPage> createState() => _MemorySearchPageState();
}

class _MemorySearchPageState extends State<MemorySearchPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  final TextEditingController _searchController =
      TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memoryService = MemoryService.instance;

    final query = _searchController.text.trim();

    final results = memoryService.searchMemories(
      query,
    );

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Search Memories',
          style: TextStyle(
            color: darkGreen,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                14,
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText:
                      'Search titles, notes, places, tags...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: mintGreen,
                  ),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.clear_rounded,
                          ),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                    borderSide:
                        const BorderSide(
                      color: softBorder,
                    ),
                  ),
                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                    borderSide:
                        const BorderSide(
                      color: softBorder,
                    ),
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                    borderSide:
                        const BorderSide(
                      color: mintGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: _buildResults(
                context,
                query,
                results,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    String query,
    List<RecordModel> results,
  ) {
    if (query.isEmpty) {
      return const _SearchPrompt();
    }

    if (results.isEmpty) {
      return const _NoResults();
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        20,
        6,
        20,
        30,
      ),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Search Results',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 18,
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
                '${results.length}',
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
          results.length,
          (index) {
            final memory = results[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == results.length - 1
                    ? 0
                    : 12,
              ),
              child: MemoryCard(
                memory: memory,
                isFavorite:
                    MemoryService.instance.isFavorite(
                  memory,
                ),
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
  }
}

class _SearchPrompt extends StatelessWidget {
  const _SearchPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF7EF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_rounded,
                color: _MemorySearchPageState.mintGreen,
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Find a memory',
              style: TextStyle(
                color: _MemorySearchPageState.darkGreen,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Search by title, description, location, or tags.',
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

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              color: _MemorySearchPageState.mintGreen,
              size: 46,
            ),

            SizedBox(height: 14),

            Text(
              'No matching memories',
              style: TextStyle(
                color: _MemorySearchPageState.darkGreen,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Try another word, location, or tag.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B7D75),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}