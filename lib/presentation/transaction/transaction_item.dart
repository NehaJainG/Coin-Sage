import 'package:coin_sage/defaults/strings.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.index,
  });
  final int index;
  final Transaction transaction;

  @override
  State<TransactionItem> createState() {
    return _TransactionItemState();
  }
}

class _TransactionItemState extends State<TransactionItem> {
  static ColorProvider colors = ColorProvider();

  int get index => widget.index % colors.colorPalette.length;

  @override
  Widget build(BuildContext context) {
    Transaction transaction = widget.transaction;
    return Container(
      margin: const EdgeInsets.fromLTRB(3, 6, 3, 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colors.colorPalette[index],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.colorPalette[index].withOpacity(0.4),
            colors.colorPalette[index].withOpacity(0.6),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Icon(
              categoryIcons[transaction.category],
              size: 30,
              //color: Colors.black,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  //softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 22,
                        color: colors.widgetColors['text'],
                      ),
                ),
                Text(dateFormatter.format(transaction.date))
              ],
            ),
          ),
          Text(
            '$rupee ${transaction.amount}',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 18,
                  color:
                      transaction.type == TransactionType.Income ? green : red,
                ),
          ),
        ],
      ),
    );
  }
}
