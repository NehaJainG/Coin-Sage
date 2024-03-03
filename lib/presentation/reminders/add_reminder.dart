import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/strings.dart';
import 'package:coin_sage/models/reminder.dart';
import 'package:flutter/material.dart';

class SetReminder extends StatefulWidget {
  SetReminder({
    super.key,
    required this.onAddReminder,
    required this.currentReminder,
    required this.currentReminderType,
    required this.currentRepeatType,
  });

  final void Function(
    TimeOfDay?,
    Reminder?,
    Repeat?,
  ) onAddReminder;
  TimeOfDay? currentReminder;
  Reminder? currentReminderType;
  Repeat? currentRepeatType;

  @override
  State<SetReminder> createState() {
    return _SetReminderState();
  }
}

class _SetReminderState extends State<SetReminder> {
  TimeOfDay? _selectedTime;
  Reminder? _reminder;
  Repeat? _repeat;

  @override
  void initState() {
    _selectedTime = widget.currentReminder;
    _reminder = widget.currentReminderType;
    _repeat = widget.currentRepeatType;
    super.initState();
  }

  void _timePicker() async {
    final selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selectedTime == null) return;

    setState(() {
      print(selectedTime);
      _selectedTime = selectedTime;
    });
  }

  void showRepeatDialog() async {
    final selectedRepeat = await showDialog<Repeat>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          // <-- SEE HERE
          title: const Text('Repeat'),
          children: <Widget>[
            for (var repeaStr in repeatStr.entries)
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop(repeaStr.key);
                },
                child: Text(repeaStr.value),
              ),
          ],
        );
      },
    );
    if (selectedRepeat == null) return;
    setState(() {
      _repeat = selectedRepeat;
    });
  }

  void showReminderDialog() async {
    final selectedReminder = await showDialog<Reminder>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          // <-- SEE HERE
          title: const Text('Alert Before'),
          children: <Widget>[
            for (var remindStr in reminderStr.entries)
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop(remindStr.key);
                },
                child: Text(remindStr.value),
              ),
          ],
        );
      },
    );
    if (selectedReminder == null) return;
    setState(() {
      _reminder = selectedReminder;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Set your Reminder',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const Spacer(),
                  exitButton(context),
                ],
              ),
              //const Divider(),
              ListTile(
                onTap: _timePicker,
                leading: const Icon(Icons.access_time_rounded),
                title: Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context)
                      : widget.currentReminder != null
                          ? widget.currentReminder!.format(context)
                          : 'Set Timings',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(),
              ListTile(
                onTap: showReminderDialog,
                leading: const Icon(Icons.notifications_none_rounded),
                title: Text(
                  reminderStr[_reminder] ?? reminderStr[Reminder.OneDayBefore]!,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(),
              ListTile(
                onTap: showRepeatDialog,
                leading: const Icon(Icons.repeat_rounded),
                title: Text(
                  repeatStr[_repeat] ?? repeatStr[Repeat.DontRepeat]!,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  print(_selectedTime);
                  widget.onAddReminder(_selectedTime, _reminder, _repeat);
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
