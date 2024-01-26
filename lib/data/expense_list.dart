import 'package:coin_sage/models/transaction.dart';
import 'package:flutter/material.dart';

final List<Transaction> transactionData = [
  Expense(
    amount: 50.0,
    date: DateTime.now().subtract(Duration(days: 5)),
    comments: 'Grocery shopping',
    category: ExpenseCategory.Groceries,
  ),
  Income(
    amount: 1000.0,
    date: DateTime.now().subtract(Duration(days: 10)),
    comments: 'Monthly salary',
    category: IncomeCategory.Salary,
    isSteady: true,
  ),
  Debt(
    amount: 200.0,
    date: DateTime.now().subtract(Duration(days: 15)),
    comments: 'Borrowed money from a friend',
    category: DebtCategory.FamilyFriend,
    returnDate: DateTime.now(),
    reminderTime: TimeOfDay.now(),
  ),
  Subscription(
    amount: 15.0,
    date: DateTime.now().subtract(Duration(days: 20)),
    comments: 'Monthly streaming subscription',
    category: SubscriptionCategory.Streaming,
    dueDate: DateTime.now(),
    reminderTime: TimeOfDay.now(),
  ),
];
