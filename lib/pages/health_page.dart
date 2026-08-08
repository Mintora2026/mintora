import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../widgets/mintora_button.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  final TextEditingController _symptomsController =
      TextEditingController();

  final TextEditingController _notesController =
      TextEditingController();

  String _wellness = 'Good';
  double _energy = 6;
  double _discomfort = 2;
  bool _isSaving = false;

  final List<_WellnessOption> _wellnessOptions = const [
    _WellnessOption(
      label: 'Great',
      emoji: '😄',
    ),
    _WellnessOption(
      label: 'Good',
      emoji: '🙂',
    ),
    _WellnessOption(
      label: 'Okay',
      emoji: '😐',
    ),
    _WellnessOption(
      label: 'Low',
      emoji: '😕',
    ),
    _WellnessOption(
      label: 'Poor',
      emoji: '😣',
    ),
  ];

  @override
  void dispose() {
    _symptomsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveHealth() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final symptoms = _symptomsController.text.trim();
    final notes = _notesController.text.trim();

    final description = [
      'Wellness: $_wellness',
      'Energy: ${_energy.round()}/10',
      'Discomfort: ${_discomfort.round()}/10',
      if (symptoms.isNotEmpty) 'Symptoms: $symptoms',
      if (notes.isNotEmpty) 'Notes: $notes',
    ].join('\n');

    final record = RecordModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      category: RecordCategory.health,
      title: 'Health',
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
        content: Text('Health record saved'),
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
          'Health',
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
                'How are you feeling physically?',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track how you feel and notice patterns over time.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'Overall Wellness',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),

              _buildWellnessSelector(),

              const SizedBox(height: 28),

              _buildSliderCard(
                title: 'Energy',
                subtitle: 'How much energy do you have today?',
                value: _energy,
                startLabel: 'Low',
                endLabel: 'High',
                onChanged: (value) {
                  setState(() {
                    _energy = value;
                  });
                },
              ),

              const SizedBox(height: 22),

              _buildSliderCard(
                title: 'Discomfort',
                subtitle: 'Are you experiencing any physical discomfort?',
                value: _discomfort,
                startLabel: 'None',
                endLabel: 'High',
                onChanged: (value) {
                  setState(() {
                    _discomfort = value;
                  });
                },
              ),

              const SizedBox(height: 28),

              const Text(
                'Symptoms',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Optional. Add anything you noticed today.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _symptomsController,
                minLines: 3,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: _textAreaDecoration(
                  'Example: Headache, tiredness, sore muscles...',
                ),
              ),

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
                'Add anything else you want to remember.',
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
                decoration: _textAreaDecoration(
                  'Write your notes...',
                ),
              ),

              const SizedBox(height: 30),

              MintoraButton(
                label: 'Save Health',
                isLoading: _isSaving,
                onPressed: _saveHealth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWellnessSelector() {
    return Row(
      children: List.generate(
        _wellnessOptions.length,
        (index) {
          final option = _wellnessOptions[index];
          final selected = option.label == _wellness;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == _wellnessOptions.length - 1
                    ? 0
                    : 8,
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _wellness = option.label;
                  });
                },
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFE4F5EB)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected
                          ? mintGreen
                          : softBorder,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        option.emoji,
                        style: const TextStyle(
                          fontSize: 27,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option.label,
                        style: TextStyle(
                          color: selected
                              ? darkGreen
                              : const Color(0xFF6B7D75),
                          fontSize: 12,
                          fontWeight: selected
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

  Widget _buildSliderCard({
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
          color: softBorder,
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

  InputDecoration _textAreaDecoration(
    String hintText,
  ) {
    return InputDecoration(
      hintText: hintText,
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
    );
  }
}

class _WellnessOption {
  final String label;
  final String emoji;

  const _WellnessOption({
    required this.label,
    required this.emoji,
  });
}