import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/record_repository.dart';
import '../models/record_model.dart';
import '../widgets/mintora_button.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  static const Color darkGreen = Color(0xFF174C3C);
  static const Color mintGreen = Color(0xFF67C78F);
  static const Color pageBackground = Color(0xFFF6FBF8);
  static const Color softBorder = Color(0xFFE5EEE8);

  final TextEditingController _amountController =
      TextEditingController();

  final TextEditingController _sourceController =
      TextEditingController();

  final TextEditingController _notesController =
      TextEditingController();

  String _transactionType = 'Expense';
  String _selectedCategory = 'Food';
  bool _isSaving = false;

  final List<_FinanceCategory> _expenseCategories = const [
    _FinanceCategory(
      label: 'Food',
      icon: Icons.restaurant_outlined,
    ),
    _FinanceCategory(
      label: 'Shopping',
      icon: Icons.shopping_bag_outlined,
    ),
    _FinanceCategory(
      label: 'Transport',
      icon: Icons.directions_car_outlined,
    ),
    _FinanceCategory(
      label: 'Bills',
      icon: Icons.receipt_long_outlined,
    ),
    _FinanceCategory(
      label: 'Fun',
      icon: Icons.celebration_outlined,
    ),
    _FinanceCategory(
      label: 'Other',
      icon: Icons.more_horiz_rounded,
    ),
  ];

  final List<_FinanceCategory> _incomeCategories = const [
    _FinanceCategory(
      label: 'Salary',
      icon: Icons.work_outline_rounded,
    ),
    _FinanceCategory(
      label: 'Bonus',
      icon: Icons.card_giftcard_rounded,
    ),
    _FinanceCategory(
      label: 'Side Hustle',
      icon: Icons.rocket_launch_outlined,
    ),
    _FinanceCategory(
      label: 'Investment',
      icon: Icons.trending_up_rounded,
    ),
    _FinanceCategory(
      label: 'Refund',
      icon: Icons.replay_rounded,
    ),
    _FinanceCategory(
      label: 'Other',
      icon: Icons.more_horiz_rounded,
    ),
  ];

  List<_FinanceCategory> get _currentCategories {
    return _transactionType == 'Expense'
        ? _expenseCategories
        : _incomeCategories;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _sourceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectTransactionType(String type) {
    if (_transactionType == type) {
      return;
    }

    setState(() {
      _transactionType = type;

      _selectedCategory = type == 'Expense'
          ? _expenseCategories.first.label
          : _incomeCategories.first.label;
    });
  }

  Future<void> _saveFinance() async {
    if (_isSaving) {
      return;
    }

    final amountText = _amountController.text.trim();

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid amount.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final source = _sourceController.text.trim();
    final notes = _notesController.text.trim();

    final description = [
      'Type: $_transactionType',
      'Amount: \$${amount.toStringAsFixed(2)}',
      'Category: $_selectedCategory',
      if (source.isNotEmpty)
        '${_transactionType == 'Expense' ? 'Merchant' : 'Source'}: $source',
      if (notes.isNotEmpty) 'Notes: $notes',
    ].join('\n');

    final record = RecordModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      category: RecordCategory.finance,
      title: 'Finance',
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
      SnackBar(
        content: Text(
          '$_transactionType saved',
        ),
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
          'Finance',
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
                'Track your money',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Keep a simple record of where your money comes from and where it goes.',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              _buildTransactionTypeSelector(),

              const SizedBox(height: 28),

              const Text(
                'Amount',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle: const TextStyle(
                    color: darkGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  hintText: '0.00',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
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

              const SizedBox(height: 28),

              const Text(
                'Category',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),

              _buildCategoryGrid(),

              const SizedBox(height: 28),

              Text(
                _transactionType == 'Expense'
                    ? 'Merchant'
                    : 'Income Source',
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Optional',
                style: TextStyle(
                  color: Color(0xFF6B7D75),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _sourceController,
                textCapitalization:
                    TextCapitalization.words,
                decoration: _inputDecoration(
                  hintText:
                      _transactionType == 'Expense'
                          ? 'Example: Grocery store'
                          : 'Example: Salary',
                  icon:
                      _transactionType == 'Expense'
                          ? Icons.store_outlined
                          : Icons
                              .account_balance_outlined,
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
                'Add anything you want to remember about this transaction.',
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
                label: _transactionType == 'Expense'
                    ? 'Save Expense'
                    : 'Save Income',
                isLoading: _isSaving,
                onPressed: _saveFinance,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2ED),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton(
              type: 'Expense',
              icon:
                  Icons.arrow_upward_rounded,
            ),
          ),
          Expanded(
            child: _buildTypeButton(
              type: 'Income',
              icon:
                  Icons.arrow_downward_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required String type,
    required IconData icon,
  }) {
    final selected =
        _transactionType == type;

    return InkWell(
      onTap: () {
        _selectTransactionType(type);
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color:
              selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? darkGreen
                  : const Color(
                      0xFF7B8C85,
                    ),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                color: selected
                    ? darkGreen
                    : const Color(
                        0xFF7B8C85,
                      ),
                fontSize: 15,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = _currentCategories;

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];

        final selected =
            category.label == _selectedCategory;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedCategory =
                  category.label;
            });
          },
          borderRadius:
              BorderRadius.circular(18),
          child: AnimatedContainer(
            duration:
                const Duration(milliseconds: 180),
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
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  color: selected
                      ? darkGreen
                      : mintGreen,
                  size: 27,
                ),
                const SizedBox(height: 8),
                Text(
                  category.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? darkGreen
                        : const Color(
                            0xFF6B7D75,
                          ),
                    fontSize: 12,
                    fontWeight: selected
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
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: softBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: softBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: mintGreen,
          width: 2,
        ),
      ),
    );
  }
}

class _FinanceCategory {
  final String label;
  final IconData icon;

  const _FinanceCategory({
    required this.label,
    required this.icon,
  });
}