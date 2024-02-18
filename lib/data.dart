import 'package:coin_sage/models/transaction.dart';
import 'package:flutter/material.dart';

final transaction = [
  Debt(
    id: '',
    amount: 100.0,
    date: DateTime.now(),
    comments: "Loan repayment",
    category: DebtCategory.Loan,
    dueDate: DateTime.now().add(Duration(days: 15)),
    reminderTime: TimeOfDay(hour: 12, minute: 30),
  ),
  Subscription(
    id: '',
    amount: 50.0,
    date: DateTime.now(),
    comments: "Monthly Netflix subscription",
    category: SubscriptionCategory.Streaming,
    dueDate: DateTime.now().add(Duration(days: 30)),
    reminderTime: TimeOfDay(hour: 10, minute: 0),
  ),
];
