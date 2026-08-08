import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../widgets/mintora_button.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);

  final TextEditingController _notesController = TextEditingController();

  String _selectedExercise = 'Walking';
  double _duration = 30;
  double _intensity = 5;
  bool _isSaving = false;

  final List<_ExerciseOption> _exerciseTypes = const [
    _ExerciseOption(
      label: 'Walking',
      icon: Icons.directions_walk_rounded,
    ),
    _ExerciseOption(
      label: 'Running',
      icon: Icons.directions_run_rounded,
    ),
    _ExerciseOption(
      label: 'Cycling',
      icon: Icons.pedal_bike_rounded,
    ),
    _ExerciseOption(
      label: 'Strength',
      icon: Icons.fitness_center_rounded,
    ),
    _ExerciseOption(
      label: 'Yoga',
      icon: Icons.self_improvement_rounded,
    ),
    _ExerciseOption(
      label: 'Other',
      icon: Icons.sports_rounded,
    ),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveExercise() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final notes = _notesController.text.trim();

    final description = [
      'Activity: $_selectedExercise',
      'Duration: ${_duration.round()} minutes',
      'Intensity: ${_intensity.round()}/10',
      if (notes.isNotEmpty) notes,
    ].join('\n');

    final record = RecordModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      category: RecordCategory.exercise,
      title: 'Exercise',
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
        content: Text('Exercise saved'),
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
          'Exercise',
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
                'What did you do today?',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track your movement and build consistent habits.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'Activity',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),

              _buildExerciseGrid(),

              const SizedBox(height: 30),

              _buildSliderCard(
                title: 'Duration',
                subtitle: 'How long did you exercise?',
                valueLabel: '${_duration.round()} min',
                value: _duration,
                min: 5,
                max: 180,
                divisions: 35,
                startLabel: '5 min',
                endLabel: '180 min',
                onChanged: (value) {
                  setState(() {
                    _duration = value;
                  });
                },
              ),

              const SizedBox(height: 22),

              _buildSliderCard(
                title: 'Intensity',
                subtitle: 'How intense was the activity?',
                valueLabel: '${_intensity.round()}/10',
                value: _intensity,
                min: 1,
                max: 10,
                divisions: 9,
                startLabel: 'Light',
                endLabel: 'Intense',
                onChanged: (value) {
                  setState(() {
                    _intensity = value;
                  });
                },
              ),

              const SizedBox(height: 30),

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
                'Anything you want to remember about this workout?',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _notesController,
                minLines: 4,
                maxLines: 7,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Add notes...',
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

              MintoraButton(
                label: 'Save Exercise',
                isLoading: _isSaving,
                onPressed: _saveExercise,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _exerciseTypes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final option = _exerciseTypes[index];
        final isSelected = option.label == _selectedExercise;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedExercise = option.label;
            });
          },
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  option.icon,
                  color: isSelected ? darkGreen : mintGreen,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  option.label,
                  style: TextStyle(
                    color: isSelected
                        ? darkGreen
                        : const Color(0xFF6B7D75),
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliderCard({
    required String title,
    required String subtitle,
    required String valueLabel,
    required double value,
    required double min,
    required double max,
    required int divisions,
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
                valueLabel,
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
            min: min,
            max: max,
            divisions: divisions,
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

class _ExerciseOption {
  final String label;
  final IconData icon;

  const _ExerciseOption({
    required this.label,
    required this.icon,
  });
}