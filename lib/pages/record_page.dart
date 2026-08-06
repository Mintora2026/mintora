import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color pageBackground = Color(0xFFF6FBF8);

  Future<void> _saveRecord({
    required BuildContext context,
    required RecordCategory category,
    required String title,
    required String description,
  }) async {
    final record = RecordModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      category: category,
      title: title,
      description: description,
      createdAt: DateTime.now(),
      growthPoints: 1,
    );

    await RecordRepository.instance.addRecord(record);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title saved'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openRecordForm({
    required BuildContext context,
    required _RecordItem item,
  }) async {
    final descriptionController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            8,
            24,
            MediaQuery.of(sheetContext).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Add details about this ${item.label.toLowerCase()} record.',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: descriptionController,
                autofocus: true,
                minLines: 3,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Write something...',
                  filled: true,
                  fillColor: pageBackground,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFE7EFEA),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFE7EFEA),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF67C78F),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final description =
                        descriptionController.text.trim();

                    if (description.isEmpty) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter some details.',
                          ),
                        ),
                      );
                      return;
                    }

                    await _saveRecord(
                      context: sheetContext,
                      category: item.category,
                      title: item.label,
                      description: description,
                    );

                    if (sheetContext.mounted) {
                      Navigator.pop(sheetContext);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      const _RecordItem(
        category: RecordCategory.mood,
        icon: Icons.sentiment_satisfied_alt_rounded,
        label: 'Mood',
        subtitle: 'How do you feel?',
        color: Color(0xFFFFC96B),
      ),
      const _RecordItem(
        category: RecordCategory.sleep,
        icon: Icons.bedtime_outlined,
        label: 'Sleep',
        subtitle: 'Track your rest',
        color: Color(0xFF7A91E8),
      ),
      const _RecordItem(
        category: RecordCategory.work,
        icon: Icons.work_outline_rounded,
        label: 'Work',
        subtitle: 'Record progress',
        color: Color(0xFF70A8F5),
      ),
      const _RecordItem(
        category: RecordCategory.study,
        icon: Icons.menu_book_rounded,
        label: 'Study',
        subtitle: 'Save learning',
        color: Color(0xFFA78BF0),
      ),
      const _RecordItem(
        category: RecordCategory.finance,
        icon: Icons.account_balance_wallet_outlined,
        label: 'Finance',
        subtitle: 'Track money',
        color: Color(0xFF64CFA1),
      ),
      const _RecordItem(
        category: RecordCategory.health,
        icon: Icons.favorite_border_rounded,
        label: 'Health',
        subtitle: 'Record wellness',
        color: Color(0xFFFF8A8A),
      ),
      const _RecordItem(
        category: RecordCategory.exercise,
        icon: Icons.directions_run_rounded,
        label: 'Exercise',
        subtitle: 'Log activity',
        color: Color(0xFFFF9F68),
      ),
      const _RecordItem(
        category: RecordCategory.water,
        icon: Icons.water_drop_outlined,
        label: 'Water',
        subtitle: 'Track hydration',
        color: Color(0xFF62B8F6),
      ),
    ];

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        title: const Text(
          'Quick Record',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
          itemCount: items.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return InkWell(
              onTap: () {
                _openRecordForm(
                  context: context,
                  item: item,
                );
              },
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFE7EFEA),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 27,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.label,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RecordItem {
  final RecordCategory category;
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;

  const _RecordItem({
    required this.category,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
  });
}