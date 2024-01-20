import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

final formatter = DateFormat.yMd();
final cardDateFormatter = DateFormat.yMMMd();

const categoryIcon = {
  ExpenseCategory.grocery: Icons.local_grocery_store_outlined,
  ExpenseCategory.leisure: Icons.movie_creation_outlined,
  ExpenseCategory.vacation: Icons.connecting_airports,
  ExpenseCategory.personal: Icons.favorite_rounded,
  ExpenseCategory.study: Icons.school_rounded,
  ExpenseCategory.work: Icons.work,
  IncomeCategory.work: Icons.work_outline,
  IncomeCategory.lended: Icons.currency_exchange_rounded,
  IncomeCategory.investment: Icons.account_balance_outlined,
  TransactionType.Debt: Icons.currency_exchange,
  TransactionType.Subcriptions: Icons.description_outlined,
};

class Transaction {
  Transaction({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });
  final String title;
  final double amount;
  final TransactionType type;
  final category;

  final DateTime date;
}

enum ExpenseCategory {
  work,
  study,
  grocery,
  vacation,
  leisure,
  personal,
}

enum IncomeCategory {
  work,
  investment,
  lended,
}

enum TransactionType {
  Income,
  Expense,
  Debt,
  Subcriptions,
}
