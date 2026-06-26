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

// dummy date
const List<Transaction> dummyTransactions = [
  Transaction(
    title: 'Netflix',
    category: 'Entertainment',
    amount: '15.99',
    date: 'Today',
    isExpense: true,
    icon: Icons.tv_rounded,
    color: Color(0xFFFF6B6B),
  ),
  Transaction(
    title: 'Salary',
    category: 'Income',
    amount: '3,250.00',
    date: 'Jun 25',
    isExpense: false,
    icon: Icons.work_rounded,
    color: Color(0xFF4ECCA3),
  ),
  Transaction(
    title: 'Grocery Store',
    category: 'Food & Drink',
    amount: '62.40',
    date: 'Jun 24',
    isExpense: true,
    icon: Icons.shopping_cart_rounded,
    color: Color(0xFFFFB347),
  ),
  Transaction(
    title: 'Uber',
    category: 'Transport',
    amount: '12.50',
    date: 'Jun 23',
    isExpense: true,
    icon: Icons.directions_car_rounded,
    color: Color(0xFF4F8EF7),
  ),
  Transaction(
    title: 'Freelance',
    category: 'Income',
    amount: '500.00',
    date: 'Jun 22',
    isExpense: false,
    icon: Icons.laptop_rounded,
    color: Color(0xFF4ECCA3),
  ),
  Transaction(
    title: 'Electric Bill',
    category: 'Utilities',
    amount: '88.00',
    date: 'Jun 21',
    isExpense: true,
    icon: Icons.bolt_rounded,
    color: Color(0xFFFFD700),
  ),
];