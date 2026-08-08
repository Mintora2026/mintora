import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../widgets/mintora_button.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);

  final TextEditingController _notesController = TextEditingController();

  TimeOfDay _bedtime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);

  double _quality = 7;
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickBedtime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _bedtime,
    );

    if (selected != null) {
      setState(() {
        _bedtime = selected;
      });
    }
  }

  Future<void> _pickWakeTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );

    if (selected != null) {
      setState(() {
        _wakeTime = selected;
      });
    }
  }

  Duration _calculateSleepDuration() {
    final bedtimeMinutes =
        (_bedtime.hour * 60) + _bedtime.minute;

    var wakeMinutes =
        (_wakeTime.hour * 60) + _wakeTime.minute;

    if (wakeMinutes <= bedtimeMinutes) {
      wakeMinutes += 24 * 60;
    }

    return Duration(
      minutes: wakeMinutes - bedtimeMinutes,
    );
  }

  String _durationLabel() {
    final duration = _calculateSleepDuration();

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (minutes == 0) {
      return '$hours h';
    }

    return '$hours h $minutes min';
  }

  Future<void> _saveSleep() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final notes = _notesController.text.trim();

    final description = [
      'Bedtime: ${_formatTimeOfDay(_bedtime)}',
      'Wake time: ${_formatTimeOfDay(_wakeTime)}',
      'Duration: ${_durationLabel()}',
      'Quality: ${_quality.round()}/10',
      if (notes.isNotEmpty) notes,
    ].join('\n');

    final record = RecordModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      category: RecordCategory.sleep,
      title: 'Sleep',
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
        content: Text('Sleep saved'),
      ),
    );

    Navigator.pop(context);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod;

    final minute =
        time.minute.toString().padLeft(2, '0');

    final period =
        time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
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
          'Sleep',
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
                'How did you sleep?',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track your rest and build healthier sleep habits.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: _buildTimeCard(
                      title: 'Bedtime',
                      time: _bedtime,
                      icon: Icons.bedtime_outlined,
                      onTap: _pickBedtime,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimeCard(
                      title: 'Wake time',
                      time: _wakeTime,
                      icon: Icons.wb_sunny_outlined,
                      onTap: _pickWakeTime,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F6ED),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Sleep Duration',
                      style: TextStyle(
                        color: Color(0xFF6B7D75),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _durationLabel(),
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildQualityCard(),

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
                'Anything you want to remember about last night?',
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
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText:
                      'Example: Slept well but woke up once...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(18),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5EEE8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5EEE8),
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

              const SizedBox(height: 28),

              MintoraButton(
                label: 'Save Sleep',
                isLoading: _isSaving,
                onPressed: _saveSleep,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required TimeOfDay time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE5EEE8),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: mintGreen,
              size: 25,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF6B7D75),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _formatTimeOfDay(time),
              style: const TextStyle(
                color: darkGreen,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityCard() {
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Sleep Quality',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${_quality.round()}/10',
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
            'How restorative did your sleep feel?',
            style: TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Slider(
            value: _quality,
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: mintGreen,
            onChanged: (value) {
              setState(() {
                _quality = value;
              });
            },
          ),
          const Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Poor',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
              Text(
                'Excellent',
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
}