import 'package:coin_sage/assets/icon.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';

import 'package:coin_sage/assets/defaults.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() {
    return _AddExpenseScreenState();
  }
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TransactionType selectedtype = TransactionType.Expense;
  late List<DropdownMenuItem> dropdownItems;
  dynamic _selectedCategory = ExpenseCategory.work;
  DateTime _selectedDate = DateTime.now();
  String _enteredTitle = '';
  double _enteredAmount = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    dropdownItems = ExpenseCategory.values
        .map(
          (category) => DropdownMenuItem(
            value: category,
            child: Row(children: [
              Icon(categoryIcon[category]),
              const SizedBox(width: 8),
              Text(category.name.toUpperCase()),
            ]),
          ),
        )
        .toList();

    super.initState();
  }

  void saveExpense() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(Transaction(
        title: _enteredTitle,
        amount: _enteredAmount,
        type: selectedtype,
        category: _selectedCategory,
        date: _selectedDate,
      ));
    }
  }

  void _currentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    if (pickedDate == null) return;
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedtype == TransactionType.Expense) {
      _selectedCategory = ExpenseCategory.work;
      dropdownItems = ExpenseCategory.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Row(children: [
                Icon(categoryIcon[category]),
                const SizedBox(width: 8),
                Text(category.name.toUpperCase()),
              ]),
            ),
          )
          .toList();
    } else if (selectedtype == TransactionType.Income) {
      _selectedCategory = IncomeCategory.work;
      dropdownItems = IncomeCategory.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Row(children: [
                Icon(categoryIcon[category]),
                const SizedBox(width: 8),
                Text(category.name.toUpperCase()),
              ]),
            ),
          )
          .toList();
    } else if (selectedtype == TransactionType.Debt) {
      _selectedCategory = TransactionType.Debt;
      dropdownItems = [
        DropdownMenuItem(
          value: TransactionType.Debt,
          child: Row(children: [
            Icon(categoryIcon[TransactionType.Debt]),
            const SizedBox(width: 8),
            Text(TransactionType.Debt.name.toUpperCase()),
          ]),
        ),
      ];
    } else {
      _selectedCategory = TransactionType.Subcriptions;
      dropdownItems = [
        DropdownMenuItem(
          value: TransactionType.Subcriptions,
          child: Row(children: [
            Icon(categoryIcon[TransactionType.Subcriptions]),
            const SizedBox(width: 8),
            Text(TransactionType.Subcriptions.name.toUpperCase()),
          ]),
        ),
      ];
    }

    return Scaffold(
      appBar: const Tab(
          child: SizedBox(
        height: 10,
      )),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Add New Transaction',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
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
                                  selectedtype = entry.key;
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
                                          ? Colors.blue
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
                  TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length > 50) {
                        return 'Must be between 1 and 50 characters.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredTitle = value!;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLength: 20,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: Text('Amount'),
                            prefix: Text('₹  '),
                          ),
                          validator: (value) {
                            final enteredAmount =
                                value == null ? 0 : double.tryParse(value);
                            if (enteredAmount == null || enteredAmount <= 0) {
                              return 'Must be valid amount';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredAmount = double.tryParse(value!)!;
                          },
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              formatter.format(_selectedDate),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontSize: 20,
                                  ),
                            ),
                            IconButton(
                              onPressed: _currentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                                size: 34,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      onChanged: (val) {
                        if (val == null) return;
                        _selectedCategory = val;
                      },
                      dropdownColor: Theme.of(context).colorScheme.onPrimary,
                      items: dropdownItems,
                    ),
                  ),
                  const SizedBox(height: 28),
                  //const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: saveExpense,
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
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
