import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../services/insight_service.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/date_header.dart';
import '../widgets/timeline_card.dart';
import 'record_detail_page.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE6EFE9);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TextEditingController _searchController =
      TextEditingController();

  RecordCategory? _selectedCategory;
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = RecordRepository.instance;
    final insightService = InsightService.instance;

    return Scaffold(
      backgroundColor: TimelinePage.pageBackground,
      appBar: AppBar(
        backgroundColor: TimelinePage.pageBackground,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Timeline',
          style: TextStyle(
            color: TimelinePage.darkGreen,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: _showSearch ? 'Close search' : 'Search',
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;

                if (!_showSearch) {
                  _searchController.clear();
                }
              });
            },
            icon: Icon(
              _showSearch
                  ? Icons.close_rounded
                  : Icons.search_rounded,
              color: TimelinePage.darkGreen,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: repository,
          builder: (context, child) {
            final allRecords = [...repository.getAll()]
              ..sort(
                (a, b) => b.createdAt.compareTo(
                  a.createdAt,
                ),
              );

            final filteredRecords = _filterRecords(
              allRecords,
            );

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                110,
              ),
              children: [
                const Text(
                  'Your life, organized by time.',
                  style: TextStyle(
                    color: Color(0xFF6B7D75),
                    fontSize: 14,
                  ),
                ),

                if (_showSearch) ...[
                  const SizedBox(height: 18),
                  _buildSearchField(),
                ],

                const SizedBox(height: 18),

                _buildCategoryFilters(),

                if (allRecords.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  AiInsightCard(
                    title: 'Timeline Insight',
                    message: insightService.buildTimelineInsight(
                      allRecords,
                    ),
                  ),
                ],

                const SizedBox(height: 26),

                if (allRecords.isEmpty)
                  const _EmptyTimeline()
                else if (filteredRecords.isEmpty)
                  _buildNoResults()
                else
                  ..._buildTimelineSections(
                    filteredRecords,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Search your timeline...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: TimelinePage.mintGreen,
        ),
        suffixIcon: _searchController.text.isEmpty
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: TimelinePage.softBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: TimelinePage.softBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: TimelinePage.mintGreen,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = <_FilterOption>[
      const _FilterOption(
        label: 'All',
        category: null,
        icon: Icons.apps_rounded,
      ),
      const _FilterOption(
        label: 'Mood',
        category: RecordCategory.mood,
        icon: Icons.sentiment_satisfied_alt_rounded,
      ),
      const _FilterOption(
        label: 'Sleep',
        category: RecordCategory.sleep,
        icon: Icons.bedtime_outlined,
      ),
      const _FilterOption(
        label: 'Work',
        category: RecordCategory.work,
        icon: Icons.work_outline_rounded,
      ),
      const _FilterOption(
        label: 'Study',
        category: RecordCategory.study,
        icon: Icons.menu_book_rounded,
      ),
      const _FilterOption(
        label: 'Finance',
        category: RecordCategory.finance,
        icon: Icons.account_balance_wallet_outlined,
      ),
      const _FilterOption(
        label: 'Health',
        category: RecordCategory.health,
        icon: Icons.favorite_border_rounded,
      ),
      const _FilterOption(
        label: 'Exercise',
        category: RecordCategory.exercise,
        icon: Icons.directions_run_rounded,
      ),
      const _FilterOption(
        label: 'Water',
        category: RecordCategory.water,
        icon: Icons.water_drop_outlined,
      ),
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = categories[index];

          final selected =
              _selectedCategory == option.category;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = option.category;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? TimelinePage.darkGreen
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? TimelinePage.darkGreen
                      : TimelinePage.softBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    option.icon,
                    size: 17,
                    color: selected
                        ? Colors.white
                        : TimelinePage.mintGreen,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    option.label,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : TimelinePage.darkGreen,
                      fontSize: 13,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<RecordModel> _filterRecords(
    List<RecordModel> records,
  ) {
    final query =
        _searchController.text.trim().toLowerCase();

    return records.where((record) {
      final categoryMatches =
          _selectedCategory == null ||
              record.category == _selectedCategory;

      if (!categoryMatches) {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }

      final title = record.title.toLowerCase();
      final description =
          record.description.toLowerCase();

      return title.contains(query) ||
          description.contains(query);
    }).toList();
  }

  List<Widget> _buildTimelineSections(
    List<RecordModel> records,
  ) {
    final grouped = _groupRecordsByDate(
      records,
    );

    final widgets = <Widget>[];

    for (final entry in grouped.entries) {
      final date = entry.key;
      final dayRecords = entry.value;

      widgets.add(
        DateHeader(
          date: date,
          recordCount: dayRecords.length,
        ),
      );

      widgets.add(
        const SizedBox(height: 16),
      );

      for (final record in dayRecords) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              bottom: 14,
            ),
            child: TimelineCard(
              record: record,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecordDetailPage(
                      record: record,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }

      widgets.add(
        const SizedBox(height: 12),
      );
    }

    return widgets;
  }

  Widget _buildNoResults() {
    final hasSearch =
        _searchController.text.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 42,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: TimelinePage.softBorder,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: TimelinePage.mintGreen,
            size: 44,
          ),
          const SizedBox(height: 14),
          const Text(
            'No matching records',
            style: TextStyle(
              color: TimelinePage.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasSearch
                ? 'Try a different search or category.'
                : 'No records found in this category.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  static Map<DateTime, List<RecordModel>>
      _groupRecordsByDate(
    List<RecordModel> records,
  ) {
    final grouped =
        <DateTime, List<RecordModel>>{};

    for (final record in records) {
      final date = DateTime(
        record.createdAt.year,
        record.createdAt.month,
        record.createdAt.day,
      );

      grouped.putIfAbsent(
        date,
        () => [],
      );

      grouped[date]!.add(record);
    }

    return grouped;
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 42,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: TimelinePage.softBorder,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.history_rounded,
            color: TimelinePage.mintGreen,
            size: 44,
          ),
          SizedBox(height: 14),
          Text(
            'No records yet',
            style: TextStyle(
              color: TimelinePage.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first record and it will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption {
  final String label;
  final RecordCategory? category;
  final IconData icon;

  const _FilterOption({
    required this.label,
    required this.category,
    required this.icon,
  });
}