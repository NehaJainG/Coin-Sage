import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static void requestNotificationPermission() async {
    //get notification permission from user
    await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    final token = await _messaging.getToken();
    print("device token: $token");
  }
}
