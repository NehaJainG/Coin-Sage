import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coin_sage/models/transaction.dart';

class UserTransactionNotifier extends StateNotifier<List<Transaction>> {
  UserTransactionNotifier() : super(const []);

  void addTransaction(Transaction newTransaction) {
    state = [...state, newTransaction];
  }
}

final userTransactionProvider =
    StateNotifierProvider<UserTransactionNotifier, List<Transaction>>(
  (ref) => UserTransactionNotifier(),
);
