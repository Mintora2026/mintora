import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/record_model.dart';

class MemoryCard extends StatelessWidget {
  final RecordModel memory;
  final VoidCallback? onTap;
  final bool isFavorite;

  const MemoryCard({
    super.key,
    required this.memory,
    this.onTap,
    this.isFavorite = false,
  });

  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color softBorder = Color(0xFFE6EFE9);
  static const Color softBackground = Color(0xFFF8FCF9);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: softBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              if (memory.mediaPath != null)
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(23),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.file(
                      File(memory.mediaPath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: const Color(
                            0xFFEAF7EF,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons
                                  .broken_image_outlined,
                              color: mintGreen,
                              size: 42,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              Padding(
                padding:
                    const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        if (memory.mediaPath == null)
                          Container(
                            width: 50,
                            height: 50,
                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                0xFFF4EAF3,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                16,
                              ),
                            ),
                            child:
                                const Icon(
                              Icons
                                  .auto_stories_outlined,
                              color:
                                  Color(
                                0xFFD17CB7,
                              ),
                              size: 25,
                            ),
                          ),

                        if (memory.mediaPath == null)
                          const SizedBox(
                            width: 14,
                          ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                memory.title,
                                maxLines: 2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  color:
                                      darkGreen,
                                  fontSize:
                                      17,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              Text(
                                _formatDate(
                                  memory
                                      .createdAt,
                                ),
                                style:
                                    const TextStyle(
                                  color:
                                      Color(
                                    0xFF84948D,
                                  ),
                                  fontSize:
                                      12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (isFavorite)
                          const Padding(
                            padding:
                                EdgeInsets.only(
                              left: 8,
                            ),
                            child: Icon(
                              Icons
                                  .favorite_rounded,
                              color:
                                  Color(
                                0xFFFF8A8A,
                              ),
                              size: 20,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                                        if (memory.description
                        .trim()
                        .isNotEmpty)
                      Text(
                        memory.description,
                        maxLines: 4,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(
                            0xFF5F716A,
                          ),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      )
                    else
                      const Text(
                        'A moment worth remembering.',
                        style: TextStyle(
                          color: Color(
                            0xFF87968F,
                          ),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                softBackground,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                            border:
                                Border.all(
                              color:
                                  softBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize
                                    .min,
                            children: [
                              const Icon(
                                Icons
                                    .schedule_rounded,
                                color:
                                    mintGreen,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                _formatTime(
                                  memory
                                      .createdAt,
                                ),
                                style:
                                    const TextStyle(
                                  color:
                                      darkGreen,
                                  fontSize:
                                      11,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (memory.mediaPath !=
                            null) ...[
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  softBackground,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                              border:
                                  Border.all(
                                color:
                                    softBorder,
                              ),
                            ),
                            child:
                                const Row(
                              mainAxisSize:
                                  MainAxisSize
                                      .min,
                              children: [
                                Icon(
                                  Icons
                                      .photo_outlined,
                                  color:
                                      mintGreen,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Photo',
                                  style:
                                      TextStyle(
                                    color:
                                        darkGreen,
                                    fontSize:
                                        11,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const Spacer(),

                        if (onTap != null) ...[
                          const Text(
                            'View memory',
                            style: TextStyle(
                              color:
                                  mintGreen,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Icon(
                            Icons
                                .chevron_right_rounded,
                            color:
                                mintGreen,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(
    DateTime date,
  ) {
    final now = DateTime.now();

    if (_sameDate(
      date,
      now,
    )) {
      return 'Today';
    }

    final yesterday = now.subtract(
      const Duration(days: 1),
    );

    if (_sameDate(
      date,
      yesterday,
    )) {
      return 'Yesterday';
    }

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
        '${date.day}, ${date.year}';
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

  static bool _sameDate(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}