import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

final formatter = DateFormat.yMd();
final dateFormatter = DateFormat.yMMMd();
final timeFormatter = DateFormat.jm();

TimeOfDay parseTimeOfDay(String t) {
  print(t);
  int hour = 0;
  if (t.endsWith('pm')) {
    hour = 12;
  }
  DateTime dateTime = DateFormat("HH:mm").parse(t);
  return TimeOfDay(hour: dateTime.hour + hour, minute: dateTime.minute);
}

String timeFormat(TimeOfDay time) {
  String addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }

  final String timePeriod = time.period.name;

  final String hourLabel = addLeadingZeroIfNeeded(time.hour);
  final String minuteLabel = addLeadingZeroIfNeeded(time.minute);

  return '$hourLabel:$minuteLabel $timePeriod';
}

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

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'comments': comments,
        'type': type.name,
        'category': category,
        'date': dateFormatter.format(date),
      };
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

  factory Expense.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    var cate;
    for (ExpenseCategory categories in ExpenseCategory.values) {
      if (categories.name == data['category']) {
        cate = categories;
      }
    }
    return Expense(
      amount: data['amount'],
      date: dateFormatter.parse(data['date']),
      comments: data['comments'],
      category: cate,
    );
  }

  @override
  String get categoryName {
    return category.toString().split('.')[1];
  }

  @override
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'comments': comments,
        'type': type.name,
        'category': categoryName,
        'date': dateFormatter.format(date),
      };
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

  factory Income.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    var cate;
    for (IncomeCategory categories in IncomeCategory.values) {
      if (categories.name == data['category']) {
        cate = categories;
      }
    }
    return Income(
      amount: data['amount'],
      date: dateFormatter.parse(data['date']),
      comments: data['comments'],
      category: cate,
      isSteady: data['isSteady'],
    );
  }

  @override
  String get categoryName {
    return category.toString().split('.')[1];
  }

  @override
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'comments': comments,
        'type': type.name,
        'category': categoryName,
        'date': dateFormatter.format(date),
        'isSteady': isSteady,
      };
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

  factory Debt.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    var cate;
    for (DebtCategory categories in DebtCategory.values) {
      if (categories.name == data['category']) {
        cate = categories;
      }
    }
    return Debt(
      amount: data['amount'],
      date: dateFormatter.parse(data['date']),
      comments: data['comments'],
      category: cate,
      returnDate: dateFormatter.parse(data['returnDate']),
      reminderTime: parseTimeOfDay(data['reminderTime']),
    );
  }

  @override
  String get categoryName {
    return category.toString().split('.')[1];
  }

  @override
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'comments': comments,
        'type': type.name,
        'category': categoryName,
        'date': dateFormatter.format(date),
        'returnDate': dateFormatter.format(returnDate),
        'reminderTime': timeFormat(reminderTime),
      };
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

  factory Subscription.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    var cate;
    for (SubscriptionCategory categories in SubscriptionCategory.values) {
      if (categories.name == data['category']) {
        cate = categories;
      }
    }
    return Subscription(
      amount: data['amount'],
      date: dateFormatter.parse(data['date']),
      comments: data['comments'],
      category: cate,
      dueDate: dateFormatter.parse(data['dueDate']),
      reminderTime: parseTimeOfDay(data['reminderTime']),
    );
  }

  @override
  String get categoryName {
    return category.toString().split('.')[1];
  }

  @override
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'comments': comments,
        'type': type.name,
        'category': categoryName,
        'date': dateFormatter.format(date),
        'dueDate': dateFormatter.format(dueDate),
        'reminderTime': timeFormat(reminderTime),
      };
}
