import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_sage/defaults/strings.dart';
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

enum Reminder {
  OnDay,
  OneDayBefore,
  TwoDayBefore,
  FiveDayBefore,
}

enum Repeat {
  DontRepeat,
  Week,
  Month,
  Year,
}

Reminder? getReminderType(String? value) {
  if (value == null) return null;
  for (var entry in reminderStr.entries) {
    if (entry.value == value) {
      return entry.key;
    }
  }
  return null;
}

Repeat? getRepeatType(String? value) {
  if (value == null) return null;
  for (var entry in repeatStr.entries) {
    if (entry.value == value) {
      return entry.key;
    }
  }
  return null;
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final String comments;
  final TransactionType type;
  final dynamic category; // Use dynamic for flexibility
  DateTime? dueDate;
  TimeOfDay? reminderTime;
  Repeat? repeat;

  Transaction({
    required this.id,
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
  Map<String, dynamic> toReminderJson() => {};
}

class Expense extends Transaction {
  Expense({
    required super.amount,
    required super.date,
    required super.comments,
    required super.id,
    required ExpenseCategory super.category,
  }) : super(
          type: TransactionType.Expense,
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
      id: document.id,
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
    required super.amount,
    required super.date,
    required super.comments,
    required IncomeCategory super.category,
    required this.isSteady,
    required super.id,
  }) : super(
          type: TransactionType.Income,
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
      id: document.id,
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
        'date': dateFormatter.format(DateTime.now()),
        'isSteady': isSteady,
      };
}

class Debt extends Transaction {
  final DateTime dueDate;
  final TimeOfDay reminderTime;
  Reminder? reminderType;
  Repeat? repeat;

  Debt({
    required super.amount,
    required super.id,
    required super.date,
    required super.comments,
    required DebtCategory super.category,
    required this.dueDate,
    required this.reminderTime,
    this.reminderType,
    this.repeat,
  }) : super(
          type: TransactionType.Debt,
        );

  factory Debt.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    dynamic categ;
    for (DebtCategory categories in DebtCategory.values) {
      if (categories.name == data['category']) {
        categ = categories;
      }
    }
    print('here');

    return Debt(
      id: document.id,
      amount: data['amount'],
      date: dateFormatter.parse(data['date']),
      comments: data['comments'],
      category: categ,
      dueDate: dateFormatter.parse(data['dueDate'] ?? data['returnDate']),
      reminderTime: parseTimeOfDay(data['reminderTime']),
      reminderType: getReminderType(data['reminderType']),
      repeat: getRepeatType(data['repeatType']),
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
        'date': dateFormatter.format(DateTime.now()),
        'dueDate': dateFormatter.format(dueDate),
        'reminderTime': timeFormat(reminderTime),
      };
  @override
  Map<String, dynamic> toReminderJson() => {
        'amount': amount,
        'comments': comments,
        'type': type.name,
        'category': categoryName,
        'date': dateFormatter.format(DateTime.now()),
        'dueDate': dateFormatter.format(dueDate),
        'reminderTime': timeFormat(reminderTime),
        'reminderType': reminderStr[reminderType],
        'repeatType': repeatStr[repeat],
      };
}

class Subscription extends Transaction {
  final DateTime dueDate;
  final TimeOfDay reminderTime;
  Reminder? reminderType;
  Repeat? repeat;

  Subscription({
    required super.amount,
    required super.id,
    required super.date,
    required super.comments,
    required SubscriptionCategory super.category,
    required this.dueDate,
    required this.reminderTime,
    this.reminderType,
    this.repeat,
  }) : super(
          type: TransactionType.Subcriptions,
        );

  factory Subscription.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    dynamic categ;
    for (SubscriptionCategory categories in SubscriptionCategory.values) {
      if (categories.name == data['category']) {
        categ = categories;
      }
    }

    return Subscription(
      id: document.id,
      amount: data['amount'],
      date: dateFormatter.parse(data['date']),
      comments: data['comments'],
      category: categ,
      dueDate: dateFormatter.parse(data['dueDate']),
      reminderTime: parseTimeOfDay(data['reminderTime']),
      reminderType: getReminderType(data['reminderType']),
      repeat: getRepeatType(data['repeatType']),
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
        'date': dateFormatter.format(DateTime.now()),
        'dueDate': dateFormatter.format(dueDate),
        'reminderTime': timeFormat(reminderTime),
      };
  @override
  Map<String, dynamic> toReminderJson() => {
        'amount': amount,
        'comments': comments,
        'type': type.name,
        'category': categoryName,
        'date': dateFormatter.format(DateTime.now()),
        'dueDate': dateFormatter.format(dueDate),
        'reminderTime': timeFormat(reminderTime),
        'reminderType': reminderStr[reminderType],
        'repeatType': repeatStr[repeat],
      };
}
