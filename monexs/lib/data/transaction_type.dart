import 'package:flutter/material.dart';

const List<String> expenseTypes = [
  'Food & Drink',
  'Transport',
  'Entertainment',
  'Utilities',
  'Shopping',
  'Other',
];

const List<String> incomeTypes = [
  'Salary',
  'Freelance',
  'Bonus',
  'Investment',
  'Other',
];

// utility function for type.
IconData expenseTypeIcon(String type) {
  switch (type) {
    case 'Food & Drink':
      return Icons.restaurant_rounded;
    case 'Transport':
      return Icons.directions_car_rounded;
    case 'Entertainment':
      return Icons.tv_rounded;
    case 'Utilities':
      return Icons.bolt_rounded;
    case 'Shopping':
      return Icons.shopping_bag_rounded;
    default:
      return Icons.receipt_rounded;
  }
}

IconData incomeTypeIcon(String type) {
  switch (type) {
    case 'Salary':
      return Icons.work_rounded;
    case 'Freelance':
      return Icons.laptop_rounded;
    case 'Bonus':
      return Icons.card_giftcard_rounded;
    case 'Investment':
      return Icons.trending_up_rounded;
    default:
      return Icons.attach_money_rounded;
  }
}


