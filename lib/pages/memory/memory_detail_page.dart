import 'dart:io';

import 'package:flutter/material.dart';

import '../../database/record_repository.dart';
import '../../models/record_model.dart';
import '../../services/media_service.dart';
import '../../services/memory_service.dart';
import 'edit_memory_page.dart';

class MemoryDetailPage extends StatefulWidget {
  final RecordModel memory;

  const MemoryDetailPage({
    super.key,
    required this.memory,
  });

  @override
  State<MemoryDetailPage> createState() =>
      _MemoryDetailPageState();
}

class _MemoryDetailPageState extends State<MemoryDetailPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);
  static const Color lightGreen = Color(0xFFEAF7EF);

  late RecordModel _memory;

  bool _isUpdatingFavorite = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _memory = widget.memory;
  }

  Future<void> _openEditMemory() async {
    final updatedMemory =
        await Navigator.push<RecordModel>(
      context,
      MaterialPageRoute(
        builder: (context) => EditMemoryPage(
          memory: _memory,
        ),
      ),
    );

    if (!mounted || updatedMemory == null) {
      return;
    }

    setState(() {
      _memory = updatedMemory;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Memory changes are now updated.',
        ),
        duration: Duration(
          milliseconds: 1200,
        ),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    if (_isUpdatingFavorite) {
      return;
    }

    setState(() {
      _isUpdatingFavorite = true;
    });

    final newValue = !_memory.isFavorite;

    try {
      await MemoryService.instance.setFavorite(
        _memory,
        newValue,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _memory = _memory.copyWith(
          isFavorite: newValue,
        );

        _isUpdatingFavorite = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newValue
                ? 'Added to Favorite Memories.'
                : 'Removed from Favorite Memories.',
          ),
          duration: const Duration(
            milliseconds: 1000,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isUpdatingFavorite = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to update favorite: $error',
          ),
        ),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Memory?',
          ),
          content: Text(
            _memory.mediaPath == null
                ? 'This memory will be permanently removed from Mintora. This action cannot be undone.'
                : 'This memory and its saved photo will be permanently removed from Mintora. This action cannot be undone.',
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
              style: FilledButton.styleFrom(
                backgroundColor:
                    const Color(0xFFD65C5C),
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

    await _deleteMemory();
  }

  Future<void> _deleteMemory() async {
    if (_isDeleting) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      final mediaPath = _memory.mediaPath;

      await RecordRepository.instance.deleteRecord(
        _memory.id,
      );

      if (mediaPath != null) {
        try {
          await MediaService.instance.deleteMedia(
            mediaPath,
          );
        } catch (_) {
          // Media cleanup failure should not restore the record.
        }
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isDeleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to delete memory: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: _memory.isFavorite
                ? 'Remove from favorites'
                : 'Add to favorites',
            onPressed: _isUpdatingFavorite
                ? null
                : _toggleFavorite,
            icon: _isUpdatingFavorite
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: mintGreen,
                    ),
                  )
                : Icon(
                    _memory.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _memory.isFavorite
                        ? const Color(0xFFFF8A8A)
                        : darkGreen,
                  ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Memory options',
            color: Colors.white,
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: darkGreen,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                _openEditMemory();
              }

              if (value == 'delete') {
                _confirmDelete();
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Edit Memory',
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: Color(
                          0xFFD65C5C,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Delete Memory',
                        style: TextStyle(
                          color: Color(
                            0xFFD65C5C,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                40,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (_memory.mediaPath != null) ...[
                    _buildPhotoCard(),
                    const SizedBox(height: 18),
                  ],

                  _buildMainCard(),

                  if (_hasMetadata) ...[
                    const SizedBox(height: 18),
                    _buildMetadataCard(),
                  ],

                  const SizedBox(height: 18),

                  _buildMemoryStatusCard(),

                  const SizedBox(height: 18),

                  _buildReflectionCard(),
                ],
              ),
            ),

            if (_isDeleting)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.08,
                  ),
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: mintGreen,
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Deleting memory...',
                              style: TextStyle(
                                color: darkGreen,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool get _hasMetadata {
    final hasLocation =
        _memory.location?.trim().isNotEmpty ??
            false;

    return hasLocation ||
        _memory.tags.isNotEmpty;
  }

  Widget _buildPhotoCard() {
    final mediaPath = _memory.mediaPath;

    if (mediaPath == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(25),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Image.file(
            File(
              mediaPath,
            ),
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return Container(
                color: lightGreen,
                child: const Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      color: mintGreen,
                      size: 48,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Photo unavailable',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
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
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF4EAF3,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                child: Icon(
                  _memory.mediaPath == null
                      ? Icons.auto_stories_rounded
                      : Icons.photo_outlined,
                  color: const Color(
                    0xFFD17CB7,
                  ),
                  size: 27,
                ),
              ),

              const Spacer(),

              if (_memory.isFavorite)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFFFEEEE,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Color(
                          0xFFFF8A8A,
                        ),
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Favorite',
                        style: TextStyle(
                          color: Color(
                            0xFFD66767,
                          ),
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            _memory.title,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: mintGreen,
                size: 17,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _formatDate(
                    _memory.createdAt,
                  ),
                  style: const TextStyle(
                    color: Color(
                      0xFF7A8C84,
                    ),
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Divider(
            color: softBorder,
          ),

          const SizedBox(height: 18),

          Text(
            _memory.description.trim().isEmpty
                ? 'A moment worth remembering.'
                : _memory.description,
            style: const TextStyle(
              color: Color(
                0xFF52675E,
              ),
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: Text(
                  '+${_memory.growthPoints} Growth',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              if (_memory.mediaPath != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_outlined,
                        color: mintGreen,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Photo Memory',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard() {
    final location =
        _memory.location?.trim() ?? '';

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
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          if (location.isNotEmpty) ...[
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: mintGreen,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(
                          color: Color(
                            0xFF83938C,
                          ),
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          color: darkGreen,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          if (location.isNotEmpty &&
              _memory.tags.isNotEmpty)
            const Padding(
              padding:
                  EdgeInsets.symmetric(
                vertical: 18,
              ),
              child: Divider(
                color: softBorder,
                height: 1,
              ),
            ),

          if (_memory.tags.isNotEmpty) ...[
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),
                  ),
                  child: const Icon(
                    Icons.sell_outlined,
                    color: mintGreen,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tags',
                        style: TextStyle(
                          color: Color(
                            0xFF83938C,
                          ),
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children:
                            _memory.tags.map(
                          (tag) {
                            return Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 11,
                                vertical: 6,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    lightGreen,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  14,
                                ),
                              ),
                              child: Text(
                                '#$tag',
                                style:
                                    const TextStyle(
                                  color:
                                      darkGreen,
                                  fontSize:
                                      12,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMemoryStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: const Icon(
              Icons.bookmark_outline_rounded,
              color: mintGreen,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preserved in Mintora',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _memory.mediaPath == null
                      ? 'This moment is part of your Memory Timeline.'
                      : 'This moment and its photo are preserved in your Memory Timeline.',
                  style: const TextStyle(
                    color: Color(
                      0xFF7A8C84,
                    ),
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
                Colors.white,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: mintGreen,
              size: 21,
            ),
          ),

          SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Memory Reflection',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Over time, Mintora will help connect memories like this into your larger life story.',
                  style: TextStyle(
                    color: Color(
                      0xFF557268,
                    ),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        '${date.day}, ${date.year} • '
        '${_formatTime(date)}';
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

    final displayHour =
        hour == 0
            ? 12
            : hour > 12
                ? hour - 12
                : hour;

    return '$displayHour:$minute $period';
  }
}