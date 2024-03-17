import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/strings.dart';

import 'package:coin_sage/models/reminder.dart';
import 'package:coin_sage/models/transaction.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({
    super.key,
  });

  @override
  State<AddReminder> createState() {
    return _AddReminderState();
  }
}

class _AddReminderState extends State<AddReminder> {
  TransactionType _type = TransactionType.Debt;
  late List<DropdownMenuItem> dropdownItems;
  final _formKey = GlobalKey<FormState>();
  double _enteredAmount = 0;
  String _enteredComments = '';
  TimeOfDay? _reminderTime;
  Alert _reminder = Alert.OneDayBefore;
  Repeat _repeat = Repeat.Month;
  DateTime? _dueDate;
  dynamic _selectedCategory;

  @override
  void initState() {
    dropdownItems = _dropdownItems(_type);
    super.initState();
  }

  void saveReminder() {
    if (_formKey.currentState!.validate()) {
      if (_dueDate == null) {
        showSnackBar('Please select Due Date', context);
        return;
      }
      if (_reminderTime == null) {
        showSnackBar('Please select ReminderTime', context);
        return;
      }

      _formKey.currentState!.save();

      Navigator.of(context).pop<Reminder>(
        Reminder(
          id: 'id',
          comments: _enteredComments,
          alert: _reminder,
          repeat: _repeat,
          amount: _enteredAmount,
          category: _selectedCategory,
          dueDate: _dueDate!,
          date: DateTime.now(),
          reminderTime: _reminderTime!,
          type: _type,
        ),
      );
    }
  }

  List<DropdownMenuItem> _dropdownItems(TransactionType type) {
    if (type == TransactionType.Subcriptions) {
      _selectedCategory = SubscriptionCategory.Streaming;
      return SubscriptionCategory.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Icon(categoryIcons[category]),
                  const SizedBox(width: 10),
                  Text(category.name),
                ],
              ),
            ),
          )
          .toList();
    }
    _selectedCategory = DebtCategory.Loan;
    return DebtCategory.values
        .map(
          (category) => DropdownMenuItem(
            value: category,
            child: Row(
              children: [
                Icon(categoryIcons[category]),
                const SizedBox(width: 10),
                Text(category.name),
              ],
            ),
          ),
        )
        .toList();
  }

  void _timePicker() async {
    final selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selectedTime == null) return;

    setState(() {
      //print(selectedTime);
      _reminderTime = selectedTime;
    });
  }

  void _dueDatePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 10, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: lastDate,
    );
    if (pickedDate == null) return;
    setState(() {
      _dueDate = pickedDate;
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
    final selectedReminder = await showDialog<Alert>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          // <-- SEE HERE
          title: const Text('Alert Before'),
          children: <Widget>[
            for (var remindStr in alertStr.entries)
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

  Widget expenseTypeWidget(
      double width, Icon icon, String title, TransactionType type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _type = type;
          dropdownItems = _dropdownItems(type);
        });
      },
      child: Container(
        width: width * 0.4,
        height: 50,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: heroBlue,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _type == type ? white : heroBlue,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    //color: black,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(12, 12, 12, keyboardSpace + 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Add  \nReminder',
                      softWrap: true,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        expenseTypeWidget(
                          width,
                          rIconList[TransactionType.Debt]!,
                          'Debt',
                          TransactionType.Debt,
                        ),
                        expenseTypeWidget(
                          width,
                          rIconList[TransactionType.Subcriptions]!,
                          'Bills',
                          TransactionType.Subcriptions,
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter Amount',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            border: InputBorder.none,
                            prefixIcon: rupeeIcon,
                          ),
                          validator: (value) {
                            if (isNotValidAmt(value)) {
                              return 'Entered valid amount';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            var amount = double.tryParse(value!);
                            _enteredAmount = amount!;
                          },
                        ),
                        const Divider(),
                        TextField(
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                            hintText: 'Enter description',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.comment,
                            ),
                          ),
                          onChanged: (value) {
                            _enteredComments = value;
                          },
                        ),
                        const Divider(),
                        //category list
                        DropdownButtonFormField(
                          padding: const EdgeInsets.only(left: 18),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          alignment: AlignmentDirectional.topStart,
                          hint: const Text('Select a category'),
                          value: _selectedCategory,
                          items: dropdownItems,
                          onChanged: (category) {
                            _selectedCategory = category;
                          },
                          onSaved: (category) {
                            _selectedCategory = category;
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: _dueDatePicker,
                    leading: const Icon(Icons.calendar_today_rounded),
                    title: Text(
                      _dueDate != null
                          ? dateFormatter.format(_dueDate!)
                          : 'Select Due Date',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: _timePicker,
                    leading: const Icon(Icons.access_time_rounded),
                    title: Text(
                      _reminderTime != null
                          ? _reminderTime!.format(context)
                          : 'Reminder Time',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: showReminderDialog,
                    leading: const Icon(Icons.notifications_none_rounded),
                    title: Text(
                      alertStr[_reminder]!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w400),
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
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: saveReminder,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
