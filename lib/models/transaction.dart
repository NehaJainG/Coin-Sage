import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

final formatter = DateFormat.yMd();
final dateFormatter = DateFormat.yMMMd();
final timeFormatter = DateFormat.jm();

enum TransactionType {
  Income,
  Expense,
  Debt,
  Subcriptions,
}

enum ExpenseCategory {
  Groceries,
  Dining,
  Entertainment,
  Transportation,
  Utilities,
  RentMortgage,
  Health,
  Education,
  PersonalCare,
  Other,
}

enum IncomeCategory {
  Salary,
  Freelance,
  Business,
  Investment,
  Rental,
  Other,
}

enum DebtCategory {
  Loan,
  Family,
  Friend,
  CreditCard,
  Other,
}

enum SubscriptionCategory {
  Streaming,
  Magazine,
  GymMembership,
  OnlineServices,
  Utilities,
  Insurance,
  Other,
}

class Transaction {
  final double amount;
  final DateTime date;
  final String comments;
  final TransactionType type;
  final dynamic category; // Use dynamic for flexibility

  Transaction({
    required this.amount,
    required this.date,
    required this.comments,
    required this.type,
    required this.category,
  });
  String get categoryName {
    return category.toString().split('.')[1];
  }
}

class Expense extends Transaction {
  Expense({
    required double amount,
    required DateTime date,
    required String comments,
    required ExpenseCategory category,
  }) : super(
          amount: amount,
          date: date,
          comments: comments,
          type: TransactionType.Expense,
          category: category,
        );

  @override
  String get categoryName {
    return category.toString().split('.')[1];
  }
}

class Income extends Transaction {
  final bool isSteady;

  Income({
    required double amount,
    required DateTime date,
    required String comments,
    required IncomeCategory category,
    required this.isSteady,
  }) : super(
          amount: amount,
          date: date,
          comments: comments,
          type: TransactionType.Income,
          category: category,
        );

  @override
  String get categoryName {
    return category.toString().split('.')[1];
  }
}

class Debt extends Transaction {
  final DateTime returnDate;
  final TimeOfDay reminderTime;

  Debt({
    required double amount,
    required DateTime date,
    required String comments,
    required DebtCategory category,
    required this.returnDate,
    required this.reminderTime,
  }) : super(
          amount: amount,
          date: date,
          comments: comments,
          type: TransactionType.Debt,
          category: category,
        );

  @override
  String get categoryName {
    return category.toString().split('.')[1];
  }
}

class Subscription extends Transaction {
  final DateTime dueDate;
  final TimeOfDay reminderTime;

  Subscription({
    required double amount,
    required DateTime date,
    required String comments,
    required SubscriptionCategory category,
    required this.dueDate,
    required this.reminderTime,
  }) : super(
          amount: amount,
          date: date,
          comments: comments,
          type: TransactionType.Subcriptions,
          category: category,
        );

  @override
  String get categoryName {
    return category.toString().split('.')[1];
  }
}
