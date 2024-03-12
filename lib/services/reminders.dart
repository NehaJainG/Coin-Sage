import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_sage/models/reminder.dart';

class ReminderServices {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> get userDB =>
      _db.collection('Users');

  static Future<List<Reminder>?> getReminders(String userID) async {
    final snapshot = await userDB.doc(userID).collection('reminders').get();

    final reminderData = snapshot.docs.map((e) {
      return Reminder.fromSnapshot(e);
    }).toList();

    return reminderData;
  }

  static Future addReminders(Reminder reminder, String userID) async {
    final data =
        await userDB.doc(userID).collection('reminders').add(reminder.toJson());
    return data;
  }

  static Future updateReminderOnPay(
      String userID, String reminderId, String updateDueDate) async {
    await userDB.doc(userID).collection('reminders').doc(reminderId).update({
      'dueDate': updateDueDate,
    });
  }

  static Future deleteReminderAfterPaid(
      String userID, String reminderID) async {
    await userDB.doc(userID).collection('reminders').doc(reminderID).delete();
  }
}
