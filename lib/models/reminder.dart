import 'package:coin_sage/defaults/strings.dart';
import 'package:coin_sage/models/transaction.dart';

import 'package:flutter/material.dart';

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

class Reminder {
  const Reminder({
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
  final String comments;
  final Alert alert;
  final Repeat repeat;
  final double amount;
  final dynamic category;
  final DateTime dueDate;
  final TimeOfDay reminderTime;
  final DateTime date;
  final TransactionType type;
}
