import 'package:coin_sage/models/reminder.dart';
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
  ),
  Subscription(
    id: '',
    amount: 50.0,
    date: DateTime.now(),
    comments: "Monthly Netflix subscription",
    category: SubscriptionCategory.Streaming,
    dueDate: DateTime.now().add(Duration(days: 30)),
  ),
];

final List<Reminder> reminders = [
  Reminder(
    comments: "Reminder 1",
    alert: Alert.OnDay,
    repeat: Repeat.DontRepeat,
    amount: 100.0,
    category: SubscriptionCategory.OnlineServices,
    dueDate: DateTime.now(),
    date: DateTime.now(),
    reminderTime: TimeOfDay.now(),
    type: TransactionType.Debt,
  ),
  Reminder(
    comments: "Reminder 2",
    alert: Alert.OneDayBefore,
    repeat: Repeat.Week,
    amount: 200.0,
    category: SubscriptionCategory.Utilities,
    dueDate: DateTime.now().add(Duration(days: 1)),
    date: DateTime.now().add(Duration(days: 1)),
    reminderTime: TimeOfDay(hour: 10, minute: 0),
    type: TransactionType.Subcriptions,
  ),
  Reminder(
    comments: "Reminder 3",
    alert: Alert.TwoDayBefore,
    repeat: Repeat.Month,
    amount: 300.0,
    category: DebtCategory.Family,
    dueDate: DateTime.now().add(Duration(days: 2)),
    date: DateTime.now().add(Duration(days: 2)),
    reminderTime: TimeOfDay(hour: 14, minute: 30),
    type: TransactionType.Debt,
  ),
  Reminder(
    comments: "Reminder 4",
    alert: Alert.FiveDayBefore,
    repeat: Repeat.Year,
    amount: 400.0,
    category: DebtCategory.Friend,
    dueDate: DateTime.now().add(Duration(days: 5)),
    date: DateTime.now().add(Duration(days: 5)),
    reminderTime: TimeOfDay(hour: 20, minute: 0),
    type: TransactionType.Subcriptions,
  ),
];
