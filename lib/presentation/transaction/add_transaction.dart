// import 'package:coin_sage/services/transaction_repo.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    super.key,
  });
  final TransactionType type = TransactionType.Expense;

  @override
  State<AddTransactionScreen> createState() {
    return _AddTransactionScreenState();
  }
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  //final TransactionRepository transRepo = TransactionRepository();
  late TransactionType selectedtype;
  late List<DropdownMenuItem> dropdownItems;
  dynamic _selectedCategory;
  dynamic _finalCategory;
  final DateTime _selectedDate = DateTime.now();
  String? _enteredComment;
  double _enteredAmount = 0;
  DateTime? _dueDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    selectedtype = widget.type;
    dropdownItems = _dropdownItems(selectedtype);
    super.initState();
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

  void saveTransaction() {
    Transaction? newTransaction;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (selectedtype == TransactionType.Expense) {
        newTransaction = Expense(
          id: 'id',
          amount: _enteredAmount,
          date: _selectedDate,
          comments: _enteredComment ?? '',
          category: _finalCategory,
        );
      } else if (selectedtype == TransactionType.Income) {
        newTransaction = Income(
          id: 'id',
          amount: _enteredAmount,
          date: _selectedDate,
          comments: _enteredComment ?? '',
          category: _finalCategory,
          isSteady: true,
        );
      } else if (selectedtype == TransactionType.Debt) {
        if (_dueDate != null) {
          newTransaction = Debt(
            id: 'id',
            amount: _enteredAmount,
            date: _selectedDate,
            comments: _enteredComment ?? '',
            category: _finalCategory,
            dueDate: _dueDate!,
          );
        } else {
          showSnackBar('Please add Return date of the Debt', context);
          return;
        }
      } else {
        if (_dueDate != null) {
          newTransaction = Subscription(
            id: 'id',
            amount: _enteredAmount,
            date: _selectedDate,
            comments: _enteredComment ?? '',
            category: _finalCategory,
            dueDate: _dueDate!,
          );
        } else {
          showSnackBar('Please add Due date of the subscription', context);
          return;
        }
      }
      Navigator.of(context).pop<Transaction>(newTransaction);
    }
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
