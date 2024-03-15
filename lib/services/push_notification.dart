import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/strings.dart';
import 'package:coin_sage/models/reminder.dart';

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

  // static Future createNotification() async {
  //   return notification.createNotification(
  //     content: NotificationContent(
  //       title: notificationTitle,
  //       body: 'User you have to pay x amount for y',
  //       id: 1,
  //       channelKey: 'alerts',
  //       category: NotificationCategory.Reminder,
  //       wakeUpScreen: true,
  //       // notificationLayout:
  //     ),
  //   );
  // }

  static Future createReminderNoti(Reminder reminder, String message) async {
    return notification.createNotification(
      schedule: NotificationCalendar(
        year: reminder.reminderDateTime.year,
        month: reminder.reminderDateTime.month,
        day: reminder.reminderDateTime.day,
        hour: reminder.reminderDateTime.hour,
        minute: reminder.reminderDateTime.minute,
      ),
      content: NotificationContent(
        title: notificationTitle,
        body: message,
        id: reminder.scheduleId,
        channelKey: 'alerts',
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
      ),
    );
  }

  Future deleteNotification(int reminderScheduleId) async {
    await notification.cancelSchedule(reminderScheduleId);
  }
}
