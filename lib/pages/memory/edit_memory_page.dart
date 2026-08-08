import 'dart:io';

import 'package:flutter/material.dart';

import '../../database/record_repository.dart';
import '../../models/record_model.dart';
import '../../services/media_service.dart';

class EditMemoryPage extends StatefulWidget {
  final RecordModel memory;

  const EditMemoryPage({
    super.key,
    required this.memory,
  });

  @override
  State<EditMemoryPage> createState() =>
      _EditMemoryPageState();
}

class _EditMemoryPageState extends State<EditMemoryPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  final TextEditingController _locationController =
      TextEditingController();

  final TextEditingController _tagsController =
      TextEditingController();

  late DateTime _selectedDate;
  late bool _isFavorite;

  String? _mediaPath;
  String? _originalMediaPath;

  bool _isSaving = false;
  bool _isPickingMedia = false;
  bool _didSave = false;

  @override
  void initState() {
    super.initState();

    _titleController.text =
        widget.memory.title;

    _descriptionController.text =
        widget.memory.description;

    _locationController.text =
        widget.memory.location ?? '';

    _tagsController.text =
        widget.memory.tags.join(', ');

    _selectedDate =
        widget.memory.createdAt;

    _isFavorite =
        widget.memory.isFavorite;

    _mediaPath =
        widget.memory.mediaPath;

    _originalMediaPath =
        widget.memory.mediaPath;
  }

  @override
  void dispose() {
    if (!_didSave &&
        _mediaPath != null &&
        _mediaPath != _originalMediaPath) {
      MediaService.instance.deleteMedia(
        _mediaPath,
      );
    }

    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _tagsController.dispose();

    super.dispose();
  }

  List<String> _parseTags(
    String rawTags,
  ) {
    return rawTags
        .split(',')
        .map(
          (tag) => tag.trim(),
        )
        .where(
          (tag) => tag.isNotEmpty,
        )
        .toSet()
        .toList();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        _selectedDate.hour,
        _selectedDate.minute,
      );
    });
  }

  Future<void> _choosePhoto() async {
    if (_isPickingMedia) {
      return;
    }

    setState(() {
      _isPickingMedia = true;
    });

    try {
      final newPath =
          await MediaService.instance.pickImageFromGallery();

      if (!mounted) {
        return;
      }

      if (newPath == null) {
        return;
      }

      final currentPath =
          _mediaPath;

      if (currentPath != null &&
          currentPath !=
              _originalMediaPath) {
        await MediaService.instance.deleteMedia(
          currentPath,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _mediaPath = newPath;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to choose photo: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingMedia = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_isPickingMedia) {
      return;
    }

    setState(() {
      _isPickingMedia = true;
    });

    try {
      final newPath =
          await MediaService.instance.takePhoto();

      if (!mounted) {
        return;
      }

      if (newPath == null) {
        return;
      }

      final currentPath =
          _mediaPath;

      if (currentPath != null &&
          currentPath !=
              _originalMediaPath) {
        await MediaService.instance.deleteMedia(
          currentPath,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _mediaPath = newPath;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to take photo: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingMedia = false;
        });
      }
    }
  }

  Future<void> _removePhoto() async {
    final currentPath =
        _mediaPath;

    if (currentPath == null) {
      return;
    }

    if (currentPath !=
        _originalMediaPath) {
      await MediaService.instance.deleteMedia(
        currentPath,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _mediaPath = null;
    });
  }

  Future<void> _showPhotoOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _mediaPath == null
                      ? 'Add Photo'
                      : 'Change Photo',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: mintGreen,
                  ),
                  title: const Text(
                    'Choose from Photos',
                  ),
                  onTap: () {
                    Navigator.pop(
                      sheetContext,
                    );

                    _choosePhoto();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera_outlined,
                    color: mintGreen,
                  ),
                  title: const Text(
                    'Take Photo',
                  ),
                  onTap: () {
                    Navigator.pop(
                      sheetContext,
                    );

                    _takePhoto();
                  },
                ),
                if (_mediaPath != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(
                        0xFFD65C5C,
                      ),
                    ),
                    title: const Text(
                      'Remove Photo',
                      style: TextStyle(
                        color: Color(
                          0xFFD65C5C,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(
                        sheetContext,
                      );

                      _removePhoto();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    final title =
        _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a memory title.',
          ),
        ),
      );

      return;
    }

    final description =
        _descriptionController.text.trim();

    final location =
        _locationController.text.trim();

    final rawTags =
        _tagsController.text.trim();

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedMemory = RecordModel(
        id: widget.memory.id,
        category:
            widget.memory.category,
        title: title,
        description: description,
        createdAt: _selectedDate,
        growthPoints:
            widget.memory.growthPoints,
        isCompleted:
            widget.memory.isCompleted,
        isFavorite: _isFavorite,
        mediaPath: _mediaPath,
        location:
            location.isEmpty ? null : location,
        tags: _parseTags(
          rawTags,
        ),
      );

      await RecordRepository.instance.updateRecord(
        updatedMemory,
      );

      final oldMediaPath =
          _originalMediaPath;

      if (oldMediaPath != null &&
          oldMediaPath !=
              _mediaPath) {
        try {
          await MediaService.instance.deleteMedia(
            oldMediaPath,
          );
        } catch (_) {
          // The edited record is already saved.
        }
      }

      if (!mounted) {
        return;
      }

      _didSave = true;
      _originalMediaPath =
          _mediaPath;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Memory updated.',
          ),
        ),
      );

      Navigator.pop(
        context,
        updatedMemory,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to update memory: $error',
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
          'Edit Memory',
          style: TextStyle(
            color: darkGreen,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            40,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Update this moment while keeping it part of your story.',
                style: TextStyle(
                  color: Color(
                    0xFF6B7F76,
                  ),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              _buildLabel(
                'Memory Title',
              ),

              const SizedBox(height: 8),

              _buildTextField(
                controller:
                    _titleController,
                hintText:
                    'Memory title',
              ),

              const SizedBox(height: 22),

              _buildLabel(
                'What happened?',
              ),

              const SizedBox(height: 8),

              _buildTextField(
                controller:
                    _descriptionController,
                hintText:
                    'Write about this moment...',
                minLines: 5,
                maxLines: 8,
              ),

              const SizedBox(height: 22),

              _buildLabel(
                'Date',
              ),

              const SizedBox(height: 8),

              _buildDateCard(),

              const SizedBox(height: 22),

              _buildLabel(
                'Location',
              ),

              const SizedBox(height: 8),

              _buildTextField(
                controller:
                    _locationController,
                hintText:
                    'e.g. Boston, MA',
                prefixIcon:
                    Icons.location_on_outlined,
              ),

              const SizedBox(height: 22),

              _buildLabel(
                'Tags',
              ),

              const SizedBox(height: 8),

              _buildTextField(
                controller:
                    _tagsController,
                hintText:
                    'e.g. family, travel, graduation',
                prefixIcon:
                    Icons.sell_outlined,
              ),

              const SizedBox(height: 8),

              const Text(
                'Separate multiple tags with commas.',
                style: TextStyle(
                  color:
                      Color(0xFF8A9992),
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 22),

              _buildFavoriteCard(),

              const SizedBox(height: 28),

              _buildMediaSection(),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving
                      ? null
                      : _saveChanges,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        darkGreen,
                    foregroundColor:
                        Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(
    String text,
  ) {
    return Text(
      text,
      style: const TextStyle(
        color: darkGreen,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int minLines = 1,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textCapitalization:
          TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                color: mintGreen,
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
    );
  }

  Widget _buildDateCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _pickDate,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: softBorder,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: mintGreen,
                size: 21,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _formatDate(
                    _selectedDate,
                  ),
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(
                  0xFF94A39C,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: SwitchListTile(
        contentPadding:
            EdgeInsets.zero,
        value: _isFavorite,
        activeThumbColor:
            mintGreen,
        title: const Text(
          'Favorite Memory',
          style: TextStyle(
            color: darkGreen,
            fontSize: 14,
            fontWeight:
                FontWeight.w700,
          ),
        ),
        subtitle: const Text(
          'Mark this as a special moment.',
          style: TextStyle(
            color: Color(
              0xFF7A8C84,
            ),
            fontSize: 12,
          ),
        ),
        secondary: Icon(
          _isFavorite
              ? Icons.favorite_rounded
              : Icons
                  .favorite_border_rounded,
          color: const Color(
            0xFFFF8A8A,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _isFavorite = value;
          });
        },
      ),
    );
  }

  Widget _buildMediaSection() {
    final mediaPath =
        _mediaPath;

    if (mediaPath == null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isPickingMedia
              ? null
              : _showPhotoOptions,
          borderRadius:
              BorderRadius.circular(22),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(
              18,
            ),
            decoration: BoxDecoration(
              color: const Color(
                0xFFEAF7EF,
              ),
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      Colors.white,
                  child: _isPickingMedia
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                mintGreen,
                          ),
                        )
                      : const Icon(
                          Icons
                              .add_photo_alternate_outlined,
                          color:
                              mintGreen,
                        ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'Add a Photo',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 15,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Choose a photo from your library or capture a new one.',
                        style: TextStyle(
                          color: Color(
                            0xFF557268,
                          ),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons
                      .chevron_right_rounded,
                  color: mintGreen,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(
                21,
              ),
            ),
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
                    color: const Color(
                      0xFFEAF7EF,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons
                            .broken_image_outlined,
                        color:
                            mintGreen,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.all(
              14,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Photo attached',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed:
                      _isPickingMedia
                          ? null
                          : _showPhotoOptions,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 18,
                  ),
                  label: const Text(
                    'Replace',
                  ),
                ),
                IconButton(
                  tooltip:
                      'Remove photo',
                  onPressed:
                      _removePhoto,
                  icon: const Icon(
                    Icons
                        .delete_outline_rounded,
                    color: Color(
                      0xFFD65C5C,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(
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
        '${date.day}, ${date.year}';
  }
}