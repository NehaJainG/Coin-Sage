import 'dart:math';

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
    int? scheduleId,
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
  }) : scheduleId = scheduleId ?? Random().nextInt(1000);

  final String id;
  final int scheduleId;
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

  DateTime get reminderDateTime {
    int subDate = 0;
    if (alert == Alert.OneDayBefore) {
      subDate = 1;
    } else if (alert == Alert.TwoDayBefore) {
      subDate = 2;
    } else if (alert == Alert.FiveDayBefore) {
      subDate = 5;
    }
    DateTime reminderDateTime1 = DateTime(dueDate.year, dueDate.month,
        dueDate.day - subDate, reminderTime.hour, reminderTime.minute, 00, 00);

    return reminderDateTime1;
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
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
      scheduleId: data['scheduleId'],
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
