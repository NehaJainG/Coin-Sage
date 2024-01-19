import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';

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
      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.70),
      shadowColor: Theme.of(context).colorScheme.onBackground,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const Spacer(),
                Icon(
                  categoryIcon[transaction.category],
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  cardDateFormatter.format(transaction.date),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                ),
                const Spacer(),
                Text(
                  'Rs. ${transaction.amount}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: transaction.type == TransactionType.expense
                            ? const Color.fromARGB(255, 255, 114, 98)
                            : const Color.fromARGB(255, 103, 249, 108),
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
