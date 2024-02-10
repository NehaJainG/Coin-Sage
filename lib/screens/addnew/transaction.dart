import 'package:coin_sage/services/transaction_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, required this.user});
  final TransactionType type = TransactionType.Expense;

  final User user;
  @override
  State<AddTransactionScreen> createState() {
    return _AddTransactionScreenState();
  }
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TransactionRepository transRepo = TransactionRepository();
  late TransactionType selectedtype;
  late List<DropdownMenuItem> dropdownItems;
  dynamic _selectedCategory;
  dynamic _finalCategory;
  final DateTime _selectedDate = DateTime.now();
  String? _enteredComment;
  double _enteredAmount = 0;
  DateTime? _dueDate;
  TimeOfDay? _reminder;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    selectedtype = widget.type;
    dropdownItems = _dropdownItems(selectedtype);
    super.initState();
  }

  //valid amount verification
  bool isNotValidAmt(String? amt) {
    if (amt == null || amt.isEmpty) return true;
    double? amount = double.tryParse(amt);
    if (amount == null || amount <= 0) {
      return true;
    }
    return false;
  }

  List<DropdownMenuItem> _dropdownItems(TransactionType type) {
    if (type == TransactionType.Income) {
      _selectedCategory = IncomeCategory.Business;
      return IncomeCategory.values
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
    } else if (type == TransactionType.Subcriptions) {
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
    } else if (type == TransactionType.Debt) {
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
    _selectedCategory = ExpenseCategory.Groceries;
    return ExpenseCategory.values
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

  void saveTransaction() async {
    Transaction? newTransaction;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (selectedtype == TransactionType.Expense) {
        newTransaction = Expense(
          amount: _enteredAmount,
          date: _selectedDate,
          comments: _enteredComment ?? '',
          category: _finalCategory,
        );
      } else if (selectedtype == TransactionType.Income) {
        newTransaction = Income(
          amount: _enteredAmount,
          date: _selectedDate,
          comments: _enteredComment ?? '',
          category: _finalCategory,
          isSteady: true,
        );
      } else if (selectedtype == TransactionType.Debt) {
        if (_dueDate != null) {
          newTransaction = Debt(
            amount: _enteredAmount,
            date: _selectedDate,
            comments: _enteredComment ?? '',
            category: _finalCategory,
            returnDate: _dueDate!,
            reminderTime: _reminder ?? TimeOfDay.now(),
          );
        } else {
          showSnackBar('Please add Return date of the Debt', context);
          return;
        }
      } else {
        if (_dueDate != null) {
          newTransaction = Subscription(
            amount: _enteredAmount,
            date: _selectedDate,
            comments: _enteredComment ?? '',
            category: _finalCategory,
            dueDate: _dueDate!,
            reminderTime: _reminder ?? TimeOfDay.now(),
          );
        } else {
          showSnackBar('Please add Due date of the subscription', context);
        }
      }

      final data =
          await transRepo.addTransaction(newTransaction!, widget.user.uid);
      print(data);
      Navigator.of(context).pop<Transaction>(newTransaction);
    }
  }

  void setReminderPara(TimeOfDay? userReminder) {
    setState(() {
      _reminder = userReminder;
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

  void setReminder() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SetReminder(
        onAddReminder: setReminderPara,
        currentReminder: _reminder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    dropdownItems = _dropdownItems(selectedtype);
    Widget additionalContent = const SizedBox();
    if (selectedtype == TransactionType.Debt ||
        selectedtype == TransactionType.Subcriptions) {
      additionalContent = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            icon: calenderIcon,
            onPressed: _dueDatePicker,
            label: Text(
              _dueDate == null
                  ? selectedtype == TransactionType.Debt
                      ? 'Pick Return Date'
                      : 'Pick Due Date'
                  : dateFormatter.format(_dueDate!),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          TextButton.icon(
            onPressed: setReminder,
            icon: _reminder != null
                ? const Icon(
                    Icons.notifications,
                  )
                : const Icon(Icons.notification_add_rounded),
            label: Text(
              'Set Remainder',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: const Tab(
          child: SizedBox(
        height: 10,
      )),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, keyboardSpace + 30),
            child: Column(
              children: [
                Text(
                  'Add New Transaction',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                //contains the buttons to change the type of transaction.
                Container(
                  //height: 70,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: iconList.entries.map((entry) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _dueDate = null;
                                _reminder = null;
                                selectedtype = entry.key;
                                _formKey.currentState!.reset();
                                dropdownItems = _dropdownItems(selectedtype);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: selectedtype == entry.key
                                        ? heroBlue
                                        : Colors.white,
                                    spreadRadius: 15,
                                  ),
                                ],
                              ),
                              child: entry.value,
                            ),
                          ),
                          Text(
                            entry.key.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                btwVertical,
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //amount field
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: 'Amount',
                            prefixIcon: rupeeIcon,
                          ),
                          validator: (value) {
                            if (isNotValidAmt(value)) {
                              return 'Invalid Input';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            var amount = double.tryParse(value!);
                            _enteredAmount = amount!;
                          },
                        ),

                        btwVertical,

                        //category list
                        DropdownButtonFormField(
                            hint: const Text('Select a category'),
                            value: _selectedCategory,
                            items: dropdownItems,
                            onChanged: (category) {
                              _finalCategory = category;
                            },
                            onSaved: (category) {
                              _finalCategory = category;
                            }),
                        btwVertical,
                        additionalContent,
                        btwVertical,
                        //comments field
                        TextFormField(
                            maxLines: 2,
                            minLines: 1,
                            decoration: inputDecor(
                                'Comments',
                                const Icon(Icons.add_comment),
                                null,
                                'Add some thoughts of yours'),
                            onSaved: (value) {
                              _enteredComment = value;
                            }),
                        btwVertical,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              onPressed: saveTransaction,
                              child: const Text('Add'),
                            ),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SetReminder extends StatefulWidget {
  SetReminder(
      {super.key, required this.onAddReminder, required this.currentReminder});

  final void Function(TimeOfDay?) onAddReminder;
  TimeOfDay? currentReminder;
  @override
  State<SetReminder> createState() {
    return _SetReminderState();
  }
}

class _SetReminderState extends State<SetReminder> {
  TimeOfDay? _selectedTime;
  void _timePicker() async {
    final selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selectedTime == null) return;

    setState(() {
      _selectedTime = selectedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedTime == null) {
      setState(() {
        _selectedTime = widget.currentReminder;
      });
    }
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.background.withOpacity(.8),
          width: double.infinity,
          padding: const EdgeInsets.all(30),
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
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 5),
                    child: Text(
                      'Timings:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.1),
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ]
                        // border: Border.all(
                        //   width: 2,
                        //   color: Theme.of(context).dividerColor,
                        // ),
                        ),
                    child: ListTile(
                      onTap: _timePicker,
                      trailing: const Icon(Icons.access_time_rounded),
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
                  ),
                ],
              ),
              //   Row(
              //     children: [
              //       IconButton(
              //
              //         icon:

              //         padding: const EdgeInsets.only(right: 20),
              //       ),

              //     ],
              //   ),
              // )

              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  print(_selectedTime);
                  widget.onAddReminder(_selectedTime);
                  Navigator.of(context).pop();
                },
                child: const Text('Add Reminder'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
