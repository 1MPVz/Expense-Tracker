import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String category;
  final String amount;
  final String date;
  final bool isExpense;
  final IconData icon;
  final Color color;

  const Transaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.icon,
    required this.color,
  });
}

// dummy data for test
//const List<Transaction> dummyTransactions = [
//  Transaction(
//    title: 'Netflix',
//    category: 'Entertainment',
//    amount: '15.99',
//    date: 'Today',
//    isExpense: true,
//    icon: Icons.tv_rounded,
//    color: Color(0xFFFF6B6B),
//  ),
//  Transaction(
//    title: 'Salary',
//    category: 'Salary',
//    amount: '3,250.00',
//    date: 'Jun 25',
//    isExpense: false,
//    icon: Icons.work_rounded,
//    color: Color(0xFF4ECCA3),
//  ),
//];

const List<Transaction> initialTransactions = [

];