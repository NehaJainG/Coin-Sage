import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.userTransaction,
  });

  final List<Transaction> userTransaction;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //itemExtent: 100,
      itemCount: userTransaction.length,
      itemBuilder: (ctx, index) =>
          TransactionItem(transaction: userTransaction[index]),
    );
  }
}
