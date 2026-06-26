import 'package:flutter/material.dart';
import '../data/transactions.dart';
import 'expense_list_page.dart';
import 'summary_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final List<Transaction> _transactions = List.of(dummyTransactions);

  static const List<String> _expenseTypes = [
    'Food & Drink',
    'Transport',
    'Entertainment',
    'Utilities',
    'Shopping',
    'Other',
  ];

  static const List<String> _incomeTypes = [
    'Salary',
    'Freelance',
    'Bonus',
    'Investment',
    'Other',
  ];

  void _openAddModal() {
    bool isExpense = true;
    String selectedType = _expenseTypes.first;
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
            final types = isExpense ? _expenseTypes : _incomeTypes;
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
                                selectedType = _expenseTypes.first;
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
                                selectedType = _incomeTypes.first;
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

                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: Colors.white54),
                      hintText: 'e.g. Grocery shopping',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF1E2434),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
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

                  TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Value',
                      labelStyle: const TextStyle(color: Colors.white54),
                      hintText: 'e.g. 45.00',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF1E2434),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
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
                            final title = _titleController.text.trim();
                            final valueText = _valueController.text.trim();
                            final amount = double.tryParse(valueText);

                            if (title.isEmpty || amount == null) {
                              return;
                            }

                            final newTransaction = Transaction(
                              title: title,
                              category: selectedType,
                              amount: amount.toStringAsFixed(2),
                              date: formatDate(selectedDate),
                              isExpense: isExpense,
                              icon: isExpense ? Icons.shopping_cart_rounded : Icons.attach_money_rounded,
                              color: isExpense ? const Color(0xFFFF6B6B) : const Color(0xFF4ECCA3),
                            );

                            setState(() {
                              _transactions.insert(0, newTransaction);
                            });

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
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
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
      body: _currentIndex == 0
          ? ExpenseListPage(transactions: _transactions)
          : SummaryPage(transactions: _transactions),
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