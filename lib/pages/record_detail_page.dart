import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';

class RecordDetailPage extends StatefulWidget {
  final RecordModel record;

  const RecordDetailPage({
    super.key,
    required this.record,
  });

  @override
  State<RecordDetailPage> createState() =>
      _RecordDetailPageState();
}

class _RecordDetailPageState
    extends State<RecordDetailPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  late RecordModel _record;

  @override
  void initState() {
    super.initState();
    _record = widget.record;
  }

  @override
  Widget build(BuildContext context) {
    final visual = _categoryVisual(
      _record.category,
    );

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkGreen,
          ),
        ),
        title: const Text(
          'Record Details',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            40,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(
                visual,
              ),

              const SizedBox(height: 24),

              _buildDateCard(),

              const SizedBox(height: 20),

              _buildContentCard(),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          _openEditDialog,
                      icon: const Icon(
                        Icons.edit_outlined,
                      ),
                      label: const Text(
                        'Edit',
                      ),
                      style:
                          OutlinedButton.styleFrom(
                        foregroundColor:
                            darkGreen,
                        side: const BorderSide(
                          color: darkGreen,
                        ),
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 16,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        _confirmDelete(
                          context,
                        );
                      },
                      icon: const Icon(
                        Icons
                            .delete_outline_rounded,
                      ),
                      label: const Text(
                        'Delete',
                      ),
                      style:
                          FilledButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFFB94A48,
                        ),
                        foregroundColor:
                            Colors.white,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 16,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    _CategoryVisual visual,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: visual.color.withValues(
                alpha: 0.16,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
            child: Icon(
              visual.icon,
              color: visual.color,
              size: 31,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _record.title,
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 25,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _categoryName(
                    _record.category,
                  ),
                  style: const TextStyle(
                    color:
                        Color(0xFF6B7D75),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(
                0xFFE7F6ED,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
            child: Text(
              '+${_record.growthPoints}',
              style: const TextStyle(
                color: darkGreen,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: mintGreen,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Created',
                  style: TextStyle(
                    color:
                        Color(0xFF6B7D75),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatDate(
                    _record.createdAt,
                  ),
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Text(
            _formatTime(
              _record.createdAt,
            ),
            style: const TextStyle(
              color: Color(
                0xFF6B7D75,
              ),
              fontSize: 14,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              color: darkGreen,
              fontSize: 18,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            _record.description.isEmpty
                ? 'No additional details.'
                : _record.description,
            style: const TextStyle(
              color: Color(0xFF536A61),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditDialog() async {
    final controller =
        TextEditingController(
      text: _record.description,
    );

    final updatedDescription =
        await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            8,
            24,
            MediaQuery.of(
                      sheetContext,
                    ).viewInsets.bottom +
                32,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Record',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 24,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _record.title,
                style: const TextStyle(
                  color:
                      Color(0xFF6B7D75),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller,
                autofocus: true,
                minLines: 6,
                maxLines: 12,
                textCapitalization:
                    TextCapitalization
                        .sentences,
                decoration:
                    InputDecoration(
                  hintText:
                      'Edit details...',
                  filled: true,
                  fillColor:
                      pageBackground,
                  contentPadding:
                      const EdgeInsets
                          .all(
                    18,
                  ),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                    borderSide:
                        const BorderSide(
                      color:
                          softBorder,
                    ),
                  ),
                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                    borderSide:
                        const BorderSide(
                      color:
                          softBorder,
                    ),
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                    borderSide:
                        const BorderSide(
                      color:
                          mintGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final value =
                        controller.text
                            .trim();

                    if (value.isEmpty) {
                      ScaffoldMessenger.of(
                        sheetContext,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Record details cannot be empty.',
                          ),
                        ),
                      );

                      return;
                    }

                    Navigator.pop(
                      sheetContext,
                      value,
                    );
                  },
                  style:
                      FilledButton
                          .styleFrom(
                    backgroundColor:
                        darkGreen,
                    foregroundColor:
                        Colors.white,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 16,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        18,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    controller.dispose();

    if (updatedDescription == null) {
      return;
    }

    final updatedRecord =
        _record.copyWith(
      description:
          updatedDescription,
    );

    await RecordRepository.instance
        .updateRecord(
      updatedRecord,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _record = updatedRecord;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Record updated',
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
  ) async {
    final shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title: const Text(
            'Delete record?',
          ),
          content: const Text(
            'This record will be permanently removed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFB94A48,
                ),
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await RecordRepository.instance
        .deleteRecord(
      _record.id,
    );

    if (!context.mounted) {
      return;
    }

    Navigator.pop(
      context,
      true,
    );
  }

  static String _formatDate(
    DateTime date,
  ) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} '
        '${date.day}, '
        '${date.year}';
  }

  static String _formatTime(
    DateTime date,
  ) {
    final hour = date.hour;

    final minute = date.minute
        .toString()
        .padLeft(
          2,
          '0',
        );

    final period =
        hour >= 12 ? 'PM' : 'AM';

    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    return '$displayHour:$minute $period';
  }

  static String _categoryName(
    RecordCategory category,
  ) {
    switch (category) {
      case RecordCategory.mood:
        return 'Mood';

      case RecordCategory.sleep:
        return 'Sleep';

      case RecordCategory.work:
        return 'Work';

      case RecordCategory.study:
        return 'Study';

      case RecordCategory.finance:
        return 'Finance';

      case RecordCategory.health:
        return 'Health';

      case RecordCategory.exercise:
        return 'Exercise';

      case RecordCategory.water:
        return 'Water';

      case RecordCategory.memory:
        return 'Memory';

      case RecordCategory.other:
        return 'Other';
    }
  }

  static _CategoryVisual _categoryVisual(
    RecordCategory category,
  ) {
    switch (category) {
      case RecordCategory.mood:
        return const _CategoryVisual(
          icon:
              Icons.sentiment_satisfied_alt_rounded,
          color: Color(0xFFFFB85C),
        );

      case RecordCategory.sleep:
        return const _CategoryVisual(
          icon:
              Icons.bedtime_outlined,
          color: Color(0xFF7A91E8),
        );

      case RecordCategory.work:
        return const _CategoryVisual(
          icon:
              Icons.work_outline_rounded,
          color: Color(0xFF70A8F5),
        );

      case RecordCategory.study:
        return const _CategoryVisual(
          icon:
              Icons.menu_book_rounded,
          color: Color(0xFFA78BF0),
        );

      case RecordCategory.finance:
        return const _CategoryVisual(
          icon: Icons
              .account_balance_wallet_outlined,
          color: Color(0xFF64CFA1),
        );

      case RecordCategory.health:
        return const _CategoryVisual(
          icon:
              Icons.favorite_border_rounded,
          color: Color(0xFFFF8A8A),
        );

      case RecordCategory.exercise:
        return const _CategoryVisual(
          icon:
              Icons.directions_run_rounded,
          color: Color(0xFFFF9F68),
        );

      case RecordCategory.water:
        return const _CategoryVisual(
          icon:
              Icons.water_drop_outlined,
          color: Color(0xFF62B8F6),
        );

      case RecordCategory.memory:
        return const _CategoryVisual(
          icon:
              Icons.photo_album_outlined,
          color: Color(0xFFE58BC8),
        );

      case RecordCategory.other:
        return const _CategoryVisual(
          icon:
              Icons.auto_awesome_rounded,
          color: mintGreen,
        );
    }
  }
}

class _CategoryVisual {
  final IconData icon;
  final Color color;

  const _CategoryVisual({
    required this.icon,
    required this.color,
  });
}