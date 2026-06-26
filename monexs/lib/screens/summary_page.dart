import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../data/transactions.dart';

class SummaryPage extends StatefulWidget {
  final List<Transaction> transactions;

  const SummaryPage({required this.transactions, super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool _showExpense = true;

  static const List<Color> _segmentColors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECCA3),
    Color(0xFF4F8EF7),
    Color(0xFFFFB347),
    Color(0xFF9B5DE5),
    Color(0xFF00B8A9),
    Color(0xFFFFD700),
  ];

  String _formatAmount(double value) {
    return value.toStringAsFixed(2);
  }

  List<_CategorySummary> _buildSummaries() {
    final filtered = widget.transactions.where((transaction) => transaction.isExpense == _showExpense);
    final totals = <String, double>{};
    double total = 0;

    for (final transaction in filtered) {
      final amount = double.tryParse(transaction.amount.replaceAll(',', '')) ?? 0;
      totals[transaction.category] = (totals[transaction.category] ?? 0) + amount;
      total += amount;
    }

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return List.generate(entries.length, (index) {
      final entry = entries[index];
      return _CategorySummary(
        category: entry.key,
        amount: entry.value,
        percentage: total > 0 ? entry.value / total : 0,
        color: _segmentColors[index % _segmentColors.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaries = _buildSummaries();
    final totalAmount = summaries.fold<double>(0, (sum, item) => sum + item.amount);

    return Container(
      color: const Color(0xFF1A1F2E),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildToggle(),
              const SizedBox(height: 24),
              _buildDonutCard(summaries, totalAmount),
              const SizedBox(height: 20),
              if (summaries.isNotEmpty) ...summaries.map(_buildSummaryRow),
              if (summaries.isEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242938),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _showExpense ? 'No expense data yet.' : 'No income data yet.',
                    style: const TextStyle(color: Colors.white54, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showExpense = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _showExpense ? const Color(0xFFFF6B6B) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Expenses',
                    style: TextStyle(
                      color: _showExpense ? Colors.white : Colors.white54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showExpense = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !_showExpense ? const Color(0xFF4ECCA3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Income',
                    style: TextStyle(
                      color: !_showExpense ? Colors.white : Colors.white54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutCard(List<_CategorySummary> summaries, double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 260,
            child: CustomPaint(
              painter: _DonutChartPainter(summaries),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _showExpense ? 'Expenses' : 'Income',
                      style: const TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatAmount(totalAmount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Total ${_showExpense ? 'spent' : 'earned'}',
                      style: const TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(_CategorySummary summary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: summary.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatAmount(summary.amount),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(summary.percentage * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySummary {
  final String category;
  final double amount;
  final double percentage;
  final Color color;

  _CategorySummary({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class _DonutChartPainter extends CustomPainter {
  final List<_CategorySummary> segments;

  _DonutChartPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.36;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 32
      ..strokeCap = StrokeCap.round;

    final total = segments.fold<double>(0, (sum, item) => sum + item.amount);
    double startAngle = -math.pi / 2;

    if (total <= 0) {
      paint.color = const Color(0xFF3A4254);
      canvas.drawArc(rect, 0, math.pi * 2, false, paint);
      return;
    }

    for (final segment in segments) {
      final sweepAngle = (segment.amount / total) * math.pi * 2;
      paint.color = segment.color;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
