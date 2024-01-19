import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key, required this.type});

  final TransactionType type;

  bool get _isExpense {
    if (type == TransactionType.expense) {
      return true;
    }

    return false;
  }

  @override
  State<AddExpenseScreen> createState() {
    return _AddExpenseScreenState();
  }
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late List<DropdownMenuItem> dropdownItems;
  dynamic _selectedCategory = ExpenseCategory.work;
  DateTime _selectedDate = DateTime.now();
  String _enteredTitle = '';
  double _enteredAmount = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (!widget._isExpense) {
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
    } else {
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
    }

    super.initState();
  }

  void saveExpense() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(Transaction(
        title: _enteredTitle,
        amount: _enteredAmount,
        type: widget.type,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Expense'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(18.0),
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              children: [
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
                        decoration: const InputDecoration(
                          label: Text('Amount'),
                          prefix: Text('Rs. '),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                    isExpanded: true,
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
    );
  }
}
