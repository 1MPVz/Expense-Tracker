import 'package:flutter/material.dart';
import '../data/transactions.dart';
import 'expense_list_page.dart';
import 'summary_page.dart';
import '../data/transaction_type.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final List<Transaction> _transactions = List.of(initialTransactions);

  // form validation state
  String? _titleErrorMessage;
  String? _valueErrorMessage;

  // compute balance values from transaction list
  double get _totalIncome => _transactions
      .where((tx) => !tx.isExpense)
      .fold(0, (sum, tx) => sum + double.parse(tx.amount.replaceAll(',', '')));

  double get _totalExpense => _transactions
      .where((tx) => tx.isExpense)
      .fold(0, (sum, tx) => sum + double.parse(tx.amount.replaceAll(',', '')));

  double get _totalBalance => _totalIncome - _totalExpense;

  // validate form fields and return true if all valid
  bool _validateForm() {
    final title = _titleController.text.trim();
    final value = _valueController.text.trim();

    if (title.isEmpty) {
      setState(() {
        _titleErrorMessage = 'Please enter a title for this transaction.';
        _valueErrorMessage = null;
      });
      return false;
    }

    if (value.isEmpty) {
      setState(() {
        _titleErrorMessage = null;
        _valueErrorMessage = 'Please enter an amount.';
      });
      return false;
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      setState(() {
        _titleErrorMessage = null;
        _valueErrorMessage = 'Enter a valid amount, such as 45.00.';
      });
      return false;
    }

    if (amount < 0) {
      setState(() {
        _titleErrorMessage = null;
        _valueErrorMessage = 'Amount cannot be negative.';
      });
      return false;
    }

    if (amount > 1000000000) {
      setState(() {
        _titleErrorMessage = null;
        _valueErrorMessage = 'Amount is too large.';
      });
      return false;
    }

    final decimalPart = value.contains('.') ? value.split('.').last : null;
    if (decimalPart != null && decimalPart.length > 2) {
      setState(() {
        _titleErrorMessage = null;
        _valueErrorMessage = 'Use up to 2 decimal places.';
      });
      return false;
    }

    setState(() {
      _titleErrorMessage = null;
      _valueErrorMessage = null;
    });

    return true;
  }

  // remove transaction and trigger recompute of balance getters
  void _deleteTransaction(Transaction tx) {
    setState(() {
      _transactions.remove(tx);
    });
  }

  void _openAddModal() {
    // reset validation errors when opening modal
    _titleErrorMessage = null;
    _valueErrorMessage = null;

    bool isExpense = true;
    String selectedType = expenseTypes.first;
    DateTime selectedDate = DateTime.now();

    String formatDate(DateTime date) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateToCheck = DateTime(date.year, date.month, date.day);

      if (dateToCheck == today) {
        return 'Today';
      } else if (dateToCheck == yesterday) {
        return 'Yesterday';
      } else {
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];

        if (date.year != now.year) {
          return '${months[date.month - 1]} ${date.day}, ${date.year}';
        }

        return '${months[date.month - 1]} ${date.day}';
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final types = isExpense ? expenseTypes : incomeTypes;
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF242938),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2434),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                isExpense = true;
                                selectedType = expenseTypes.first;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isExpense ? const Color(0xFFFF6B6B) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Expense',
                                  style: TextStyle(
                                    color: isExpense ? Colors.white : Colors.white54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                isExpense = false;
                                selectedType = incomeTypes.first;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isExpense ? const Color(0xFF4ECCA3) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Income',
                                  style: TextStyle(
                                    color: !isExpense ? Colors.white : Colors.white54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // title field — turns red border when empty
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (_) {
                      if (_titleErrorMessage != null) {
                        setModalState(() => _titleErrorMessage = null);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        color: _titleErrorMessage != null ? const Color(0xFFFF6B6B) : Colors.white54,
                      ),
                      hintText: 'e.g. Grocery shopping',
                      hintStyle: const TextStyle(color: Colors.white38),
                      errorText: _titleErrorMessage,
                      errorStyle: const TextStyle(color: Color(0xFFFF6B6B)),
                      filled: true,
                      fillColor: _titleErrorMessage != null
                          ? const Color(0xFFFF6B6B).withValues(alpha: 0.08)
                          : const Color(0xFF1E2434),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: _titleErrorMessage != null
                            ? const BorderSide(color: Color(0xFFFF6B6B), width: 1.5)
                            : BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: _titleErrorMessage != null
                            ? const BorderSide(color: Color(0xFFFF6B6B), width: 1.5)
                            : const BorderSide(color: Color(0xFF4F8EF7), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Type',
                      labelStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF1E2434),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isDense: true,
                        isExpanded: true,
                        value: selectedType,
                        dropdownColor: const Color(0xFF1E2434),
                        items: types
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setModalState(() {
                            selectedType = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  GestureDetector(
                    onTap: () async {
                      // use built in show Date Picker function for calendar
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFF4F8EF7),
                                onPrimary: Colors.white,
                                surface: Color(0xFF242938),
                                onSurface: Colors.white,
                              ),
                              dialogTheme: const DialogThemeData(
                                backgroundColor: Color(0xFF242938),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setModalState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: TextEditingController(text: formatDate(selectedDate)),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: const TextStyle(color: Colors.white54),
                          hintText: 'Select date',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF1E2434),
                          suffixIcon: const Icon(Icons.calendar_today, color: Colors.white54),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // value field — turns red border when empty or not a number
                  TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (_) {
                      if (_valueErrorMessage != null) {
                        setModalState(() => _valueErrorMessage = null);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Value',
                      labelStyle: TextStyle(
                        color: _valueErrorMessage != null ? const Color(0xFFFF6B6B) : Colors.white54,
                      ),
                      hintText: 'e.g. 45.00',
                      hintStyle: const TextStyle(color: Colors.white38),
                      errorText: _valueErrorMessage,
                      errorStyle: const TextStyle(color: Color(0xFFFF6B6B)),
                      filled: true,
                      fillColor: _valueErrorMessage != null
                          ? const Color(0xFFFF6B6B).withValues(alpha: 0.08)
                          : const Color(0xFF1E2434),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: _valueErrorMessage != null
                            ? const BorderSide(color: Color(0xFFFF6B6B), width: 1.5)
                            : BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: _valueErrorMessage != null
                            ? const BorderSide(color: Color(0xFFFF6B6B), width: 1.5)
                            : const BorderSide(color: Color(0xFF4F8EF7), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(52),
                            side: const BorderSide(color: Colors.white12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            _titleController.clear();
                            _valueController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F8EF7),
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            // run validation before submitting
                            final isValid = _validateForm();
                            setModalState(() {}); // re-render modal with error state

                            if (!isValid) return;

                            final title = _titleController.text.trim();
                            final amount = double.parse(_valueController.text.trim());

                            // create new transaction object and set it as a state
                            final newTransaction = Transaction(
                              title: title,
                              category: selectedType,
                              amount: amount.toStringAsFixed(2),
                              date: formatDate(selectedDate),
                              isExpense: isExpense,
                              icon: isExpense ? expenseTypeIcon(selectedType) : incomeTypeIcon(selectedType),
                              color: isExpense ? const Color(0xFFFF6B6B) : const Color(0xFF4ECCA3),
                            );

                            // setState triggers recompute of _totalIncome, _totalExpense, _totalBalance getters
                            setState(() {
                              _transactions.insert(0, newTransaction);
                            });

                            // clear controller when press enter
                            _titleController.clear();
                            _valueController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Enter',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2E),
      // this is the header of the app
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        elevation: 0,
        title: const Text(
          'MonExs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF4F8EF7),
              child: Text(
                'P',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // balance card always stays fixed above the scrollable content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F8EF7), Color(0xFF2E5FD4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // total balance auto-updates when transactions change
                  Text(
                    '\$${_totalBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _BalanceStat(
                        icon: Icons.arrow_downward_rounded,
                        label: 'Income',
                        // income auto-updates when transactions change
                        value: '\$${_totalIncome.toStringAsFixed(2)}',
                        iconColor: const Color(0xFF4ECCA3),
                      ),
                      const SizedBox(width: 32),
                      _BalanceStat(
                        icon: Icons.arrow_upward_rounded,
                        label: 'Expenses',
                        // expense auto-updates when transactions change
                        value: '\$${_totalExpense.toStringAsFixed(2)}',
                        iconColor: const Color(0xFFFF6B6B),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // handle page navigation between expense list and summary page
          Expanded(
            child: _currentIndex == 0
                ? ExpenseListPage(transactions: _transactions, onDelete: _deleteTransaction)
                : SummaryPage(transactions: _transactions),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddModal,
        backgroundColor: const Color(0xFF4F8EF7),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF242938),
        selectedItemColor: const Color(0xFF4F8EF7),
        unselectedItemColor: Colors.white38,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Summary',
          ),
        ],
      ),
    );
  }
}

// Balance Stat widget used in the fixed balance card
class _BalanceStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _BalanceStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}