import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:coin_sage/models/room.dart';
import 'package:coin_sage/models/transaction.dart' as app;
import 'package:coin_sage/services/user_repo.dart';

class RoomRepositories {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> get roomDB =>
      _db.collection("Rooms");

  //to get all rooms
  static Future<List<Room>?> getUserRooms(String email) async {
    final snapshot = await roomDB.where("members", arrayContains: email).get();
    final roomsData = snapshot.docs.map(
      (e) {
        final room = Room.fromSnapshot(e);

        return room;
      },
    ).toList();
    return roomsData;
  }

  //to add room
  static Future addRoom(Room room, String userEmail) async {
    final roomID = await roomDB.add(
      room.toJson(
        userEmail,
      ),
    );

    //add requests to other members of room

    for (String e in room.members!) {
      if (e != userEmail) {
        UserRepo.addRequestId(e, {roomID.id: room.title});
      }
    }

    //add room id of user creating the room
    UserRepo.addRoomId(userEmail, roomID.id);
  }

  static Future<Room> getRoomById(String roomId) async {
    final snapshot = await roomDB.doc(roomId).get();
    final room = Room.fromSnapshot(snapshot);
    return room;
  }

  //to get all requests of the users:
  static Future<List<Room>> getRoomsRequests(String email) async {
    final request = await UserRepo.getUserRequestID(email);
    final snapshot = await _db.collection("Requests").doc(request).get();

    final roomTitle = snapshot.data()!.values.toList();
    final roomSnapshot = await roomDB.where("title", whereIn: roomTitle).get();
    final roomsData = roomSnapshot.docs.map(
      (e) {
        final room = Room.fromSnapshot(e);
        return room;
      },
    ).toList();
    return roomsData;
  }

  //add transactions in the room
  static Future addTransactionToRoom(
      app.Transaction transaction, String roomID, String userEmail) async {
    final data = await roomDB
        .doc(roomID)
        .collection('transaction-$userEmail')
        .add(transaction.toJson());
    if (transaction.type == app.TransactionType.Income) {
      await roomDB.doc(roomID).update({
        'totalAmount': FieldValue.increment(-transaction.amount),
      });
    } else {
      await roomDB.doc(roomID).update({
        'totalAmount': FieldValue.increment(transaction.amount),
      });
    }
    return data;
  }

  // //add reminders in the room
  // static Future addReminders(app.Transaction transaction, String roomID) async {
  //   final data = await roomDB
  //       .doc(roomID)
  //       .collection('reminders')
  //       .add(transaction.toJson());
  //   return data;
  // }

  static Future<List<app.Transaction>?> getRoomReminders(String roomID) async {
    final snapshot = await roomDB.doc(roomID).collection('reminders').get();

    final transactionData = snapshot.docs.map((e) {
      final transactionType = e.data()['type'];

      if (transactionType == app.TransactionType.Debt.name) {
        return app.Debt.fromSnapshot(e);
      }
      return app.Subscription.fromSnapshot(e);
    }).toList();

    return transactionData;
  }

  static Future<List<app.Transaction>?> getRoomTransactions(
      String roomID, List<String> members) async {
    List<app.Transaction> transactionData = [];
    for (String member in members) {
      //print(member);
      final snapshot =
          await roomDB.doc(roomID).collection('transaction-$member').get();

      final data = snapshot.docs.map((e) {
        final transactionType = e.data()['type'];

        if (transactionType == app.TransactionType.Expense.name) {
          return app.Expense.fromSnapshot(e);
        } else if (transactionType == app.TransactionType.Income.name) {
          return app.Income.fromSnapshot(e);
        } else if (transactionType == app.TransactionType.Debt.name) {
          return app.Debt.fromSnapshot(e);
        }
        return app.Subscription.fromSnapshot(e);
      });
      transactionData.addAll(data);
    }
    return transactionData;
  }

  static Future<Map<String, double>> getStats(
      String roomId, String userEmail) async {
    //to get the expense that the current user made
    final room = await roomDB.doc(roomId).get();
    final roomTotal = room.data()!['totalAmount'];
    final snapshot =
        await roomDB.doc(roomId).collection('transaction-$userEmail').get();

    double totalExpense = 0;
    double invested = 0;
    snapshot.docs.forEach((element) {
      final data = element.data();
      //print(data['type']);
      if (data['type'] == app.TransactionType.Income.name) {
        double expense = data['amount']!;
        invested += expense;
      } else {
        double expense = data['amount']!;
        totalExpense += expense;
      }
    });
    //print(invested);
    //print(totalExpense);
    //print(roomTotal);
    return {
      'Total Cost': roomTotal.toDouble(),
      'You Owe': totalExpense,
      'You Invested': invested,
    };
  }
}
