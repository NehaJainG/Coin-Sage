import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/strings.dart';
import 'package:coin_sage/models/reminder.dart';
import 'package:coin_sage/models/transaction.dart';
import 'package:flutter/material.dart';

class PushNotifications {
  static final AwesomeNotifications notification = AwesomeNotifications();

  static void init() {
    notification.initialize(
      "resource://drawable/res_notification_logo",
      [
        NotificationChannel(
          channelGroupKey: 'Alerts',
          channelKey: 'alerts',
          channelName: 'Payment Reminders',
          channelDescription: 'To receive your payment reminders',
          playSound: true,
          onlyAlertOnce: true,
          importance: NotificationImportance.High,
          defaultColor: heroBlue,
          ledColor: heroBlue,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'alerts',
          channelGroupName: 'Personal Alerts',
        ),
      ],
    );
    print('it worked');
  }

  Future userRequest() async {
    final isAllowed = await notification.isNotificationAllowed();
    if (isAllowed) {
      return;
    } else {
      notification.requestPermissionToSendNotifications(
        channelKey: 'alerts',
      );
    }
  }

  static Future createNotification(DateTime reminderDate) async {
    print(reminderDate.toString());
    return notification.createNotification(
      schedule: NotificationCalendar(
        year: reminderDate.year,
        month: reminderDate.month,
        day: reminderDate.day,
        hour: reminderDate.hour,
        minute: reminderDate.minute,
      ),
      content: NotificationContent(
        title: notificationTitle,
        body: 'User you have to pay x amount for y',
        id: Random().nextInt(100),
        channelKey: 'alerts',
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
        // notificationLayout:
      ),
    );
  }

  static Future createReminderNoti(TimeOfDay reminderTime, DateTime dueDate,
      Alert reminder, String message) async {
    final reminderDate = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    if (reminder == Alert.OneDayBefore) {
      reminderDate.subtract(const Duration(days: 1));
    } else if (reminder == Alert.TwoDayBefore) {
      reminderDate.subtract(const Duration(days: 2));
    } else if (reminder == Alert.FiveDayBefore) {
      reminderDate.subtract(const Duration(days: 5));
    }

    return notification.createNotification(
      schedule: NotificationCalendar(
        year: reminderDate.year,
        month: reminderDate.month,
        day: reminderDate.day,
        hour: reminderDate.hour,
        minute: reminderDate.minute,
      ),
      content: NotificationContent(
        title: notificationTitle,
        body: message,
        id: 1,
        channelKey: 'alerts',
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
      ),
    );
  }

  void newNotiConfig(Transaction t) {}

  Future deleteNotification() async {
    notification.cancelSchedule(1);
  }

  /// method to detect when a new notification is created and schedule it
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
  }
}
