import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../widgets/mintora_button.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  final TextEditingController _projectController =
      TextEditingController();

  final TextEditingController _taskController =
      TextEditingController();

  final TextEditingController _notesController =
      TextEditingController();

  double _duration = 60;

  String _priority = 'Medium';

  bool _completed = false;

  bool _isSaving = false;

  @override
  void dispose() {
    _projectController.dispose();
    _taskController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveWork() async {
    if (_isSaving) {
      return;
    }

    final task = _taskController.text.trim();

    if (task.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final project = _projectController.text.trim();
    final notes = _notesController.text.trim();

    final description = [
      if (project.isNotEmpty) 'Project: $project',
      'Task: $task',
      'Duration: ${_formatDuration(_duration.round())}',
      'Priority: $_priority',
      'Status: ${_completed ? 'Completed' : 'In Progress'}',
      if (notes.isNotEmpty) 'Notes: $notes',
    ].join('\n');

    final record = RecordModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      category: RecordCategory.work,
      title: 'Work',
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
        content: Text('Work saved'),
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
          'Work',
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
                'What are you working on?',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Capture your progress and build a record of what you accomplish.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              _buildSectionTitle(
                'Project',
                'Optional',
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _projectController,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: _inputDecoration(
                  hintText: 'Example: Mintora',
                  icon: Icons.folder_outlined,
                ),
              ),

              const SizedBox(height: 26),

              _buildSectionTitle(
                'Task',
                'Required',
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _taskController,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: _inputDecoration(
                  hintText: 'What did you work on?',
                  icon: Icons.task_alt_rounded,
                ),
              ),

              const SizedBox(height: 26),

              _buildDurationCard(),

              const SizedBox(height: 24),

              _buildPrioritySection(),

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
                'Add progress, results, challenges, or anything worth remembering.',
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
                  hintText: 'Write your work notes...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.all(18),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: softBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: softBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: mintGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              MintoraButton(
                label: 'Save Work',
                isLoading: _isSaving,
                onPressed: _saveWork,
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
                  'Time Spent',
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
            'How much time did you spend on this work?',
            style: TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Slider(
            value: _duration,
            min: 15,
            max: 480,
            divisions: 31,
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
                '8 hours',
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

  Widget _buildPrioritySection() {
    final priorities = [
      'Low',
      'Medium',
      'High',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
            color: darkGreen,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: priorities.map((priority) {
            final selected =
                _priority == priority;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right:
                      priority == priorities.last
                          ? 0
                          : 10,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _priority = priority;
                    });
                  },
                  borderRadius:
                      BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 180,
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(
                              0xFFE4F5EB,
                            )
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? mintGreen
                            : softBorder,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      priority,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected
                            ? darkGreen
                            : const Color(
                                0xFF6B7D75,
                              ),
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
                        ? 'Completed'
                        : 'Still in progress',
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