import 'package:flutter/material.dart';
import '../data/transactions.dart';
import 'transaction_detail_page.dart';

class ExpenseListPage extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(Transaction) onDelete;

  const ExpenseListPage({
    super.key,
    required this.transactions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          ...transactions.map(
            (tx) => Dismissible(
              // unique key per transaction required by Dismissible
              key: ValueKey(tx),
              direction: DismissDirection.horizontal,
              background: _DeleteBackground(alignment: Alignment.centerLeft),
              secondaryBackground: _DeleteBackground(alignment: Alignment.centerRight),
              onDismissed: (_) => onDelete(tx),

              // tap to navigate to detail page
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          TransactionDetailPage(transaction: tx),
                      transitionsBuilder: (_, animation, __, child) {
                        final slide = Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ));
                        final fade = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeIn,
                        );
                        return SlideTransition(
                          position: slide,
                          child: FadeTransition(opacity: fade, child: child),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 350),
                    ),
                  );
                },
                child: _TransactionTile(transaction: tx),
              ),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// Red background shown behind tile when swiping
class _DeleteBackground extends StatelessWidget {
  final Alignment alignment;

  const _DeleteBackground({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF3B3B),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3B3B).withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_rounded, color: Colors.white, size: 22),
          SizedBox(width: 8),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

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
                    ? '-\฿${transaction.amount}'
                    : '+\฿${transaction.amount}',
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