import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as fs;

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/models/reminder.dart';

import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/colors.dart';

import 'package:coin_sage/services/transaction_repo.dart';
import 'package:coin_sage/services/reminders.dart';

// ignore: must_be_immutable
class ReminderItem extends StatefulWidget {
  const ReminderItem({
    super.key,
    required this.reminder,
    required this.user,
  });

  final Reminder reminder;
  final fs.User user;

  @override
  State<ReminderItem> createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  late bool isDue;

  void onPaid() async {
    //add to Transaciton
    Transaction newTransaction = widget.reminder.convertToTransaction();
    await TransactionRepository.addTransaction(newTransaction, widget.user.uid);

    //update the due date to next due Date
    widget.reminder.updateDueDateOnPaid();

    //if the the reminder is set as dont repeat, so delete once paid
    if (widget.reminder.repeat == Repeat.DontRepeat) {
      await ReminderServices.deleteReminderAfterPaid(
        widget.user.uid,
        widget.reminder.id,
      );
      return;
    }

    //update the local details to database
    await ReminderServices.updateReminderOnPay(
      widget.user.uid,
      widget.reminder.id,
      dateFormatter.format(widget.reminder.dueDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.reminder.type.name;
    if (title.isNotEmpty) {
      title = widget.reminder.comments.substring(0, 1).toUpperCase() +
          widget.reminder.comments.substring(1);
    }
    Duration dueDay = widget.reminder.dueDate.difference(DateTime.now());
    isDue = dueDay.isNegative;
    String due = dueDay.inDays == 0
        ? dueDay.inHours == 0
            ? '${dueDay.inMinutes.abs()} due min'
            : '${dueDay.inHours.abs()} due hr'
        : '${dueDay.inDays.abs()} Due day';
    if (!dueDay.isNegative) {
      due = DateFormat.MMMMd().format(widget.reminder.dueDate);
    }
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.fromLTRB(15, 7, 15, 7),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 27, 26, 85),
            Color.fromARGB(255, 31, 37, 68),
            Color.fromARGB(255, 7, 15, 43),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
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
              Icon(
                categoryIcons[widget.reminder.category],
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.95),
              ),
              const SizedBox(width: 5),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                '₹ ${widget.reminder.amount}',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                decoration: BoxDecoration(
                  color: isDue
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      due,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.access_time_sharp),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.reminder.type.name,
                style: Theme.of(context).textTheme.labelLarge,
              ),
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
                      const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
                  decoration: BoxDecoration(
                    color: heroBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Paid',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          //color: black,
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
