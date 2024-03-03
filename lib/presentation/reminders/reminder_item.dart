import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/strings.dart';
import 'package:coin_sage/services/transaction_repo.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ReminderItem extends StatefulWidget {
  const ReminderItem({
    super.key,
    required this.transaction,
    required this.user,
  });

  final Transaction transaction;
  final User user;

  @override
  State<ReminderItem> createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  late bool isDue;

  void onPaid() async {
    DateTime newDueDate = widget.transaction.dueDate!;

    await TransactionRepository.addTransaction(
        widget.transaction, widget.user.uid);
    await TransactionRepository.updateReminderOnPay(widget.user.uid,
        widget.transaction.id, dateFormatter.format(newDueDate));
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.transaction.type.name;
    if (title.isNotEmpty) {
      title = widget.transaction.comments.substring(0, 1).toUpperCase() +
          widget.transaction.comments.substring(1);
    }
    int dueDay = DateTime.now().difference(widget.transaction.date).inDays;
    isDue = dueDay < 0;
    String due = '$dueDay Due days';
    if (dueDay > 0) {
      due = DateFormat.MMMMd().format(widget.transaction.dueDate!);
    }
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 16, 31, 53),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: lightGrey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Icon(categoryIcons[widget.transaction.category],
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.95)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                '₹ ${widget.transaction.amount}',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 3, 10, 3),
                decoration: BoxDecoration(
                  color: isDue
                      ? Theme.of(context)
                          .colorScheme
                          .errorContainer
                          .withOpacity(0.5)
                      : Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      due,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: null,
                  child: Text(repeatStr[widget.transaction.repeat] ?? 'Month')),
              GestureDetector(
                onTap: () {
                  onPaid();
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text('Added to your expenses list'),
                      //action: SnackBarAction(label: 'Undo', onPressed: () {}),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 45, vertical: 6),
                  decoration: BoxDecoration(
                    color: maroon,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Paid',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
