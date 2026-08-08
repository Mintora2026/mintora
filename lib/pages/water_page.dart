import 'package:flutter/material.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../widgets/mintora_button.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  final TextEditingController _notesController =
      TextEditingController();

  int _amountMl = 250;
  int _dailyGoalMl = 2000;
  bool _isSaving = false;

  final List<_WaterOption> _options = const [
    _WaterOption(
      label: 'Small',
      amountMl: 250,
      icon: Icons.local_drink_outlined,
    ),
    _WaterOption(
      label: 'Glass',
      amountMl: 350,
      icon: Icons.local_drink_rounded,
    ),
    _WaterOption(
      label: 'Bottle',
      amountMl: 500,
      icon: Icons.water_drop_outlined,
    ),
    _WaterOption(
      label: 'Large',
      amountMl: 750,
      icon: Icons.water_drop_rounded,
    ),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveWater() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final notes = _notesController.text.trim();

    final percent =
        ((_amountMl / _dailyGoalMl) * 100).round();

    final description = [
      'Water: $_amountMl ml',
      'Daily goal: $_dailyGoalMl ml',
      'This drink: $percent% of daily goal',
      if (notes.isNotEmpty) 'Notes: $notes',
    ].join('\n');

    final record = RecordModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      category: RecordCategory.water,
      title: 'Water',
      description: description,
      createdAt: DateTime.now(),
      growthPoints: 1,
    );

    await RecordRepository.instance.addRecord(
      record,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Water saved'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        (_amountMl / _dailyGoalMl).clamp(0.0, 1.0);

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
          'Water',
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Stay hydrated',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track your water and build a healthier daily habit.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              _buildAmountCard(progress),

              const SizedBox(height: 28),

              const Text(
                'Quick Add',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),

              _buildQuickAddGrid(),

              const SizedBox(height: 28),

              _buildGoalCard(),

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
                'Optional. Add anything you want to remember.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _notesController,
                minLines: 3,
                maxLines: 6,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Add notes...',
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
                label: 'Save Water',
                isLoading: _isSaving,
                onPressed: _saveWater,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard(double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF174C3C),
            Color(0xFF2D7A5E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.water_drop_rounded,
            color: Colors.white,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            '$_amountMl ml',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(progress * 100).round()}% of your daily goal',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Color(0xFF9EE76B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: _options.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final option = _options[index];
        final selected =
            _amountMl == option.amountMl;

        return InkWell(
          onTap: () {
            setState(() {
              _amountMl = option.amountMl;
            });
          },
          borderRadius:
              BorderRadius.circular(18),
          child: AnimatedContainer(
            duration:
                const Duration(milliseconds: 180),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFE4F5EB)
                  : Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color: selected
                    ? mintGreen
                    : softBorder,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  option.icon,
                  color: selected
                      ? darkGreen
                      : mintGreen,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
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
                      const SizedBox(height: 2),
                      Text(
                        '${option.amountMl} ml',
                        style: const TextStyle(
                          color: Color(
                            0xFF83928C,
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
      },
    );
  }

  Widget _buildGoalCard() {
    return Container(
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Daily Goal',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$_dailyGoalMl ml',
                style: const TextStyle(
                  color: mintGreen,
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose your daily hydration target.',
            style: TextStyle(
              color: Color(0xFF6B7D75),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Slider(
            value: _dailyGoalMl.toDouble(),
            min: 1000,
            max: 4000,
            divisions: 12,
            activeColor: mintGreen,
            onChanged: (value) {
              setState(() {
                _dailyGoalMl =
                    value.round();
              });
            },
          ),
          const Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1000 ml',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
              Text(
                '4000 ml',
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

class _WaterOption {
  final String label;
  final int amountMl;
  final IconData icon;

  const _WaterOption({
    required this.label,
    required this.amountMl,
    required this.icon,
  });
}