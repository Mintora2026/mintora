import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);

  final TextEditingController _journalController = TextEditingController();

  int _selectedMood = 2;
  double _energy = 5;
  double _stress = 5;
  bool _isSaving = false;

  final List<_MoodOption> _moods = const [
    _MoodOption(
      emoji: '😄',
      label: 'Great',
      score: 5,
    ),
    _MoodOption(
      emoji: '🙂',
      label: 'Good',
      score: 4,
    ),
    _MoodOption(
      emoji: '😐',
      label: 'Okay',
      score: 3,
    ),
    _MoodOption(
      emoji: '😔',
      label: 'Low',
      score: 2,
    ),
    _MoodOption(
      emoji: '😢',
      label: 'Bad',
      score: 1,
    ),
  ];

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  Future<void> _saveMood() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final mood = _moods[_selectedMood];
    final journal = _journalController.text.trim();

    final description = [
      '${mood.emoji} ${mood.label}',
      'Energy: ${_energy.round()}/10',
      'Stress: ${_stress.round()}/10',
      if (journal.isNotEmpty) journal,
    ].join('\n');

    final record = RecordModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      category: RecordCategory.mood,
      title: 'Mood',
      description: description,
      createdAt: DateTime.now(),
      growthPoints: 1,
    );

    await RecordRepository.instance.addRecord(record);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood saved'),
      ),
    );

    Navigator.pop(context);
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
          'Mood',
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How are you feeling?',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Take a moment to check in with yourself.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),

              _buildMoodSelector(),

              const SizedBox(height: 30),

              _buildSliderSection(
                title: 'Energy',
                subtitle: 'How energized do you feel?',
                value: _energy,
                startLabel: 'Low',
                endLabel: 'High',
                onChanged: (value) {
                  setState(() {
                    _energy = value;
                  });
                },
              ),

              const SizedBox(height: 28),

              _buildSliderSection(
                title: 'Stress',
                subtitle: 'How stressed do you feel?',
                value: _stress,
                startLabel: 'Calm',
                endLabel: 'Stressed',
                onChanged: (value) {
                  setState(() {
                    _stress = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              const Text(
                'Journal',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Anything you want to remember about today?',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _journalController,
                minLines: 5,
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Write your thoughts here...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5EEE8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5EEE8),
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

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveMood,
                  style: FilledButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    _isSaving ? 'Saving...' : 'Save Mood',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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

  Widget _buildMoodSelector() {
    return Row(
      children: List.generate(
        _moods.length,
        (index) {
          final mood = _moods[index];
          final isSelected = index == _selectedMood;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == _moods.length - 1 ? 0 : 8,
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedMood = index;
                  });
                },
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFE4F5EB)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? mintGreen
                          : const Color(0xFFE5EEE8),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        mood.emoji,
                        style: const TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mood.label,
                        style: TextStyle(
                          color: isSelected
                              ? darkGreen
                              : const Color(0xFF6B7D75),
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliderSection({
    required String title,
    required String subtitle,
    required double value,
    required String startLabel,
    required String endLabel,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE5EEE8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${value.round()}/10',
                style: const TextStyle(
                  color: mintGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: mintGreen,
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                startLabel,
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
              Text(
                endLabel,
                style: const TextStyle(
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
}

class _MoodOption {
  final String emoji;
  final String label;
  final int score;

  const _MoodOption({
    required this.emoji,
    required this.label,
    required this.score,
  });
}