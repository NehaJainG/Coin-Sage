import 'package:coin_sage/defaults/icon.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/services/transaction_repo.dart';
import 'package:coin_sage/presentation/reminders/reminder_item.dart';

import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/colors.dart';

class Reminders extends StatefulWidget {
  const Reminders({
    super.key,
    required this.appBar,
    required this.isDrawerOpen,
    required this.user,
  });

  final bool isDrawerOpen;
  final Widget Function(void Function()? onRefresh) appBar;

  final User user;

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  bool isLoading = false;
  @override
  void initState() {
    getReminder();
    super.initState();
  }

  List<Transaction> userReminder = [];

  void getReminder() async {
    setState(() {
      isLoading = true;
    });
    List<Transaction>? list =
        await TransactionRepository.getReminders(widget.user.uid);
    if (list == null) {
      return;
    }

    userReminder = [];

    setState(() {
      userReminder.addAll(list);
      userReminder.sort((n1, n2) {
        return n2.dueDate!.compareTo(n1.dueDate!);
      });
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('I see no reminders in your list'),
    );
    if (userReminder.isNotEmpty) {
      content = Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: userReminder.length,
          addAutomaticKeepAlives: false,
          itemBuilder: (context, index) {
            return ReminderItem(
                transaction: userReminder[index], user: widget.user);
          },
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: black,
            blurRadius: 30,
          ),
        ],
        borderRadius: BorderRadius.circular(widget.isDrawerOpen ? 20 : 0),
      ),
      child: Column(
        children: [
          widget.appBar(getReminder),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 20),
              Icon(Icons.payment_outlined,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.9)),
              const SizedBox(width: 10),
              Text(
                'Payment Reminder',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                icon: addIcon,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 2),
          isLoading
              ? Center(
                  child: circularProgress,
                )
              : content,
        ],
      ),
    );
  }
}
