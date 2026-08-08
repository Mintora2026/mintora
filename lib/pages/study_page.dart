import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../widgets/mintora_button.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  final TextEditingController _courseController =
      TextEditingController();

  final TextEditingController _topicController =
      TextEditingController();

  final TextEditingController _notesController =
      TextEditingController();

  double _duration = 60;
  double _difficulty = 5;
  bool _completed = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _courseController.dispose();
    _topicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveStudy() async {
    if (_isSaving) {
      return;
    }

    final topic = _topicController.text.trim();

    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a study topic.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final course = _courseController.text.trim();
    final notes = _notesController.text.trim();

    final description = [
      if (course.isNotEmpty) 'Course: $course',
      'Topic: $topic',
      'Study time: ${_formatDuration(_duration.round())}',
      'Difficulty: ${_difficulty.round()}/10',
      'Status: ${_completed ? 'Completed' : 'In Progress'}',
      if (notes.isNotEmpty) 'Notes: $notes',
    ].join('\n');

    final record = RecordModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      category: RecordCategory.study,
      title: 'Study',
      description: description,
      createdAt: DateTime.now(),
      growthPoints: _completed ? 2 : 1,
      isCompleted: _completed,
    );

    await RecordRepository.instance.addRecord(record);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Study saved'),
      ),
    );

    Navigator.pop(context);
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '$hours h';
    }

    return '$hours h $remainingMinutes min';
  }

  @override
  Widget build(BuildContext context) {
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
          'Study',
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
            12,
            20,
            40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What did you learn today?',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track what you study and build a record of your learning.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              _buildSectionTitle(
                'Course or Subject',
                'Optional',
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _courseController,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: _inputDecoration(
                  hintText: 'Example: MBA / Finance / Spanish',
                  icon: Icons.school_outlined,
                ),
              ),

              const SizedBox(height: 26),

              _buildSectionTitle(
                'Study Topic',
                'Required',
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _topicController,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: _inputDecoration(
                  hintText: 'What did you study?',
                  icon: Icons.menu_book_rounded,
                ),
              ),

              const SizedBox(height: 26),

              _buildDurationCard(),

              const SizedBox(height: 24),

              _buildDifficultyCard(),

              const SizedBox(height: 24),

              _buildCompletionCard(),

              const SizedBox(height: 28),

              const Text(
                'Notes',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Save key ideas, questions, or anything worth reviewing later.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _notesController,
                minLines: 4,
                maxLines: 7,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Write your study notes...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: softBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: softBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: mintGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              MintoraButton(
                label: 'Save Study',
                isLoading: _isSaving,
                onPressed: _saveStudy,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String badge,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: darkGreen,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F6ED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              color: Color(0xFF557268),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(
        icon,
        color: mintGreen,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: softBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: softBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: mintGreen,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Study Time',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _formatDuration(
                  _duration.round(),
                ),
                style: const TextStyle(
                  color: mintGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'How long did you study?',
            style: TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Slider(
            value: _duration,
            min: 15,
            max: 360,
            divisions: 23,
            activeColor: mintGreen,
            onChanged: (value) {
              setState(() {
                _duration = value;
              });
            },
          ),
          const Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '15 min',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
              Text(
                '6 hours',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: softBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Difficulty',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${_difficulty.round()}/10',
                style: const TextStyle(
                  color: mintGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'How challenging was the material?',
            style: TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Slider(
            value: _difficulty,
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: mintGreen,
            onChanged: (value) {
              setState(() {
                _difficulty = value;
              });
            },
          ),
          const Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Easy',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
              Text(
                'Hard',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard() {
    return InkWell(
      onTap: () {
        setState(() {
          _completed = !_completed;
        });
      },
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _completed
              ? const Color(0xFFE4F5EB)
              : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _completed
                ? mintGreen
                : softBorder,
            width: _completed ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _completed
                    ? mintGreen
                    : const Color(
                        0xFFF1F6F3,
                      ),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Icon(
                _completed
                    ? Icons.check_rounded
                    : Icons
                        .radio_button_unchecked_rounded,
                color: _completed
                    ? Colors.white
                    : const Color(
                        0xFF83928C,
                      ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    _completed
                        ? 'Study session completed'
                        : 'Still studying',
                    style: const TextStyle(
                      color: darkGreen,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tap to change the status.',
                    style: TextStyle(
                      color: Color(
                        0xFF6B7D75,
                      ),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}