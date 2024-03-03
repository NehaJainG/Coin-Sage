import 'package:coin_sage/defaults/strings.dart';

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
