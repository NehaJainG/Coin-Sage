import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/assets/icon.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({super.key, required this.transaction});

  final Transaction transaction;

  @override
  State<TransactionItem> createState() {
    return _TransactionItemState();
  }
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    Transaction transaction = widget.transaction;
    return Card(
      surfaceTintColor: Colors.white54,
      elevation: 4,
      //borderOnForeground: false,
      //color: Colors.white,
      //shadowColor: Colors.red,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      child: Column(
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 14,
        //   vertical: 8,
        // ),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: transaction.type == TransactionType.Expense
                  ? const Color.fromARGB(255, 255, 114, 98)
                  : const Color.fromARGB(255, 103, 249, 108),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            width: double.infinity,
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'title',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        //color: Colors.white,
                      ),
                ),
                const Spacer(),
                Icon(
                  categoryIcons[transaction.category],
                  //color: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Row(
              children: [
                Text(
                  dateFormatter.format(transaction.date),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        //color: Colors.white,
                      ),
                ),
                const Spacer(),
                Text(
                  'Rs. ${transaction.amount}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: transaction.type == TransactionType.Expense
                            ? const Color.fromARGB(255, 255, 114, 98)
                            : const Color.fromARGB(255, 103, 249, 108),
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
