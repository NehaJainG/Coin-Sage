import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;

import 'package:coin_sage/defaults/strings.dart';
import 'package:coin_sage/models/transaction.dart';

enum Alert {
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

Alert? getReminderType(String? value) {
  if (value == null) return null;
  for (var entry in alertStr.entries) {
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

dynamic getCategory(String name, enumList) {
  for (dynamic item in enumList) {
    if (item.toString().split('.').last == name) return item;
  }
}

class Reminder {
  Reminder({
    required this.id,
    required this.comments,
    required this.alert,
    required this.repeat,
    required this.amount,
    required this.category,
    required this.dueDate,
    required this.date,
    required this.reminderTime,
    required this.type,
  });
  final String id;
  final String comments;
  final Alert alert;
  final Repeat repeat;
  final double amount;
  final dynamic category;
  DateTime dueDate;
  final TimeOfDay reminderTime;
  final DateTime date;
  final TransactionType type;
  bool paid = false;

  String get categoryName {
    return category.toString().split('.')[1];
  }

  String get title {
    if (comments.isEmpty) {
      return categoryName;
    }
    return comments;
  }

  Map<String, dynamic> toJson() {
    return {
      'comments': comments,
      'alert': alert.name,
      'repeat': repeat.name,
      'amount': amount,
      'category': categoryName,
      'dueDate': dueDate.toIso8601String(),
      'date': date.toIso8601String(),
      'reminderTime': timeFormat(reminderTime),
      'type': type.name,
    };
  }

  factory Reminder.fromSnapshot(
      fs.DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    //what type of transaction is to be reminded!
    TransactionType type = getCategory(data['type'], TransactionType.values);

    //what are different category in tht type of transaction, creating the list of values
    //so it becomes to get enum of cateogry(in string) using method defined.
    dynamic categoryList = SubscriptionCategory.values;
    if (type == TransactionType.Debt) {
      categoryList = DebtCategory.values;
    }

    //finally return the reminder object.
    return Reminder(
      id: document.id,
      comments: data['comments'],
      alert: getCategory(data['alert'], Alert.values),
      repeat: getCategory(data['repeat'], Repeat.values),
      amount: data['amount'],
      category: getCategory(data['category'], categoryList),
      dueDate: DateTime.parse(data['dueDate']),
      date: DateTime.parse(data['date']),
      reminderTime: parseTimeOfDay(data['reminderTime']),
      type: type,
    );
  }

  Transaction convertToTransaction() {
    if (type == TransactionType.Debt) {
      return Debt(
        amount: amount,
        id: 'id',
        date: DateTime.now(),
        comments: comments,
        category: category,
        dueDate: dueDate,
      );
    }

    return Subscription(
      amount: amount,
      id: 'id',
      date: DateTime.now(),
      comments: comments,
      category: category,
      dueDate: dueDate,
    );
  }

  void updateDueDateOnPaid() {
    if (repeat == Repeat.DontRepeat) {
      paid = true;
      return;
    }
    if (repeat == Repeat.Month) {
      dueDate.add(
        const Duration(days: 28),
      );
    } else if (repeat == Repeat.Week) {
      dueDate.add(
        const Duration(days: 7),
      );
    } else if (repeat == Repeat.Year) {
      dueDate = DateTime(
        dueDate.year + 1,
        dueDate.month,
        dueDate.day,
      );
    }
  }
}
