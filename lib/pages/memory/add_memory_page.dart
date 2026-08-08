import 'package:flutter/material.dart';

import '../../database/record_repository.dart';
import '../../models/record_model.dart';

class AddMemoryPage extends StatefulWidget {
  const AddMemoryPage({super.key});

  @override
  State<AddMemoryPage> createState() => _AddMemoryPageState();
}

class _AddMemoryPageState extends State<AddMemoryPage> {
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

  DateTime _selectedDate = DateTime.now();

  bool _isFavorite = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
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

  Future<void> _saveMemory() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _locationController.text.trim();
    final tags = _tagsController.text.trim();

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

    setState(() {
      _isSaving = true;
    });

    final details = <String>[
      if (description.isNotEmpty)
        description,
      if (location.isNotEmpty)
        'Location: $location',
      if (tags.isNotEmpty)
        'Tags: $tags',
      if (_isFavorite)
        'Favorite: Yes',
    ];

    final memory = RecordModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      category: RecordCategory.memory,
      title: title,
      description: details.join('\n'),
      createdAt: _selectedDate,
      growthPoints: 2,
    );

    await RecordRepository.instance.addRecord(
      memory,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Memory saved.',
        ),
      ),
    );

    Navigator.pop(
      context,
      true,
    );
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
          'Add Memory',
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
                'Save a meaningful moment and make it part of your story.',
                style: TextStyle(
                  color: Color(0xFF6B7F76),
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
                controller: _titleController,
                hintText:
                    'e.g. Graduation Day',
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

              const SizedBox(height: 22),

              _buildFavoriteCard(),

              const SizedBox(height: 28),

              _buildMediaPlaceholder(),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      _isSaving
                          ? null
                          : _saveMemory,
                  style:
                      FilledButton.styleFrom(
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
                          'Save Memory',
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
                color: Color(0xFF94A39C),
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
            color: Color(0xFF7A8C84),
            fontSize: 12,
          ),
        ),
        secondary: const Icon(
          Icons.favorite_border_rounded,
          color: Color(0xFFFF8A8A),
        ),
        onChanged: (value) {
          setState(() {
            _isFavorite = value;
          });
        },
      ),
    );
  }

  Widget _buildMediaPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EF),
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
              Icons.photo_camera_outlined,
              color: mintGreen,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Photos & Media',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Photo, video, voice, and document attachments will be added in the next Memory upgrade.',
                  style: TextStyle(
                    color:
                        Color(0xFF557268),
                    fontSize: 12,
                    height: 1.4,
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

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}