import 'package:coin_sage/data.dart';
import 'package:coin_sage/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:coin_sage/presentation/reminders/add_reminder.dart';
import 'package:coin_sage/presentation/reminders/reminder_item.dart';

import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';

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

  List<Reminder> userReminder = reminders;

  void getReminder() async {
    setState(() {
      isLoading = true;
    });
    // List<Reminder>? list =
    //     await TransactionRepository.getReminders(widget.user.uid);
    // if (list == null) {
    //   return;
    // }

    userReminder = [];

    setState(() {
      // userReminder.addAll(list);
      // userReminder.sort((n1, n2) {
      //   return n2.dueDate!.compareTo(n1.dueDate!);
      // });
      userReminder = reminders;
      isLoading = false;
    });
  }

  List<Widget> centerWidget(Widget child) {
    return [
      const Spacer(),
      child,
      const Spacer(),
    ];
  }

  void addReminder() async {
    final newReminder = await Navigator.of(context).push<Reminder>(
      MaterialPageRoute(
        builder: (ctx) => AddReminder(),
      ),
    );
    if (newReminder == null) {
      return;
    }
    setState(() {
      userReminder.add(newReminder);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = centerWidget(
      const Center(
        child: Text('I see no reminders in your list'),
      ),
    );
    if (userReminder.isNotEmpty) {
      content = [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: userReminder.length,
            addAutomaticKeepAlives: false,
            itemBuilder: (context, index) {
              return ReminderItem(
                  reminder: userReminder[index], user: widget.user);
            },
          ),
        )
      ];
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
        //mainAxisAlignment: MainAxisAlignment.center,
        //ssmainAxisSize: MainAxisSize.min,
        children: [
          Column(
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
                    onPressed: addReminder,
                  ),
                ],
              ),
              const SizedBox(height: 2),
            ],
          ),
          if (isLoading)
            ...centerWidget(Center(
              child: circularProgress,
            ))
          else
            ...content,
        ],
      ),
    );
  }
}
