import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _openAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF242938),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return const SizedBox(
          height: 400,
          // TODO: pp add modal here
        );
      },
    );
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
      body: _currentIndex == 0 ? const _ExpenseListPage() : const _SummaryPage(),
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

// --- Expense List Page ---

class _ExpenseListPage extends StatelessWidget {
  const _ExpenseListPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance card
          Container(
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
                const Text(
                  '\$4,285.50',
                  style: TextStyle(
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
                      value: '\$6,500.00',
                      iconColor: const Color(0xFF4ECCA3),
                    ),
                    const SizedBox(width: 32),
                    _BalanceStat(
                      icon: Icons.arrow_upward_rounded,
                      label: 'Expenses',
                      value: '\$2,214.50',
                      iconColor: const Color(0xFFFF6B6B),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Recent Transactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          ..._dummyTransactions.map(
            (tx) => _TransactionTile(transaction: tx),
          ),

          // Extra bottom padding so FAB doesn't cover last item
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// --- Summary Page (placeholder) ---

class _SummaryPage extends StatelessWidget {
  const _SummaryPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Summary — coming soon',
        style: TextStyle(color: Colors.white38, fontSize: 16),
      ),
    );
  }
}

// --- Sub-widgets ---

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

class _TransactionTile extends StatelessWidget {
  final _Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: transaction.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(transaction.icon, color: transaction.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.category,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.isExpense
                    ? '-\$${transaction.amount}'
                    : '+\$${transaction.amount}',
                style: TextStyle(
                  color: transaction.isExpense
                      ? const Color(0xFFFF6B6B)
                      : const Color(0xFF4ECCA3),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                transaction.date,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Transaction {
  final String title;
  final String category;
  final String amount;
  final String date;
  final bool isExpense;
  final IconData icon;
  final Color color;

  const _Transaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.icon,
    required this.color,
  });
}


// Test Data
const _dummyTransactions = [
  _Transaction(
    title: 'Netflix',
    category: 'Entertainment',
    amount: '15.99',
    date: 'Today',
    isExpense: true,
    icon: Icons.tv_rounded,
    color: Color(0xFFFF6B6B),
  ),
  _Transaction(
    title: 'Salary',
    category: 'Income',
    amount: '3,250.00',
    date: 'Jun 25',
    isExpense: false,
    icon: Icons.work_rounded,
    color: Color(0xFF4ECCA3),
  ),
  _Transaction(
    title: 'Grocery Store',
    category: 'Food & Drink',
    amount: '62.40',
    date: 'Jun 24',
    isExpense: true,
    icon: Icons.shopping_cart_rounded,
    color: Color(0xFFFFB347),
  ),
  _Transaction(
    title: 'Uber',
    category: 'Transport',
    amount: '12.50',
    date: 'Jun 23',
    isExpense: true,
    icon: Icons.directions_car_rounded,
    color: Color(0xFF4F8EF7),
  ),
  _Transaction(
    title: 'Freelance',
    category: 'Income',
    amount: '500.00',
    date: 'Jun 22',
    isExpense: false,
    icon: Icons.laptop_rounded,
    color: Color(0xFF4ECCA3),
  ),
  _Transaction(
    title: 'Electric Bill',
    category: 'Utilities',
    amount: '88.00',
    date: 'Jun 21',
    isExpense: true,
    icon: Icons.bolt_rounded,
    color: Color(0xFFFFD700),
  ),
];