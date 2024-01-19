import 'package:coin_sage/models/transaction.dart';

final transactionList = [
  Transaction(
    title: 'Flutter course',
    amount: 500,
    type: TransactionType.expense,
    category: ExpenseCategory.study,
    date: DateTime(2023, 10, 10, 17, 30),
  ),
  Transaction(
    title: 'Friends out',
    amount: 800,
    type: TransactionType.expense,
    category: ExpenseCategory.leisure,
    date: DateTime(2024, 1, 10),
  ),
  Transaction(
    title: 'Refill',
    amount: 1000,
    type: TransactionType.expense,
    category: ExpenseCategory.grocery,
    date: DateTime(
      2023,
      11,
      10,
    ),
  ),
];
