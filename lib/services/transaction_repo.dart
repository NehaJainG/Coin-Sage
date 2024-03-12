import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:coin_sage/models/transaction.dart' as app;

class TransactionRepository {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> get userDB =>
      _db.collection('Users');

  static Future addTransaction(
      app.Transaction transaction, String userID) async {
    final data = await userDB
        .doc(userID)
        .collection('transactions')
        .add(transaction.toJson());
    return data;
  }

  static Future<List<app.Transaction>?> getTransactions(String userID) async {
    final snapshot = await userDB.doc(userID).collection('transactions').get();

    final transactionData = snapshot.docs.map((e) {
      final transactionType = e.data()['type'];

      if (transactionType == app.TransactionType.Expense.name) {
        return app.Expense.fromSnapshot(e);
      } else if (transactionType == app.TransactionType.Income.name) {
        return app.Income.fromSnapshot(e);
      } else if (transactionType == app.TransactionType.Debt.name) {
        return app.Debt.fromSnapshot(e);
      }
      return app.Subscription.fromSnapshot(e);
    }).toList();
    return transactionData;
  }
}
