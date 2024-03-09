import 'package:coin_sage/models/transaction.dart';

final transaction = [
  Debt(
    id: '',
    amount: 100.0,
    date: DateTime.now(),
    comments: "Loan repayment",
    category: DebtCategory.Loan,
    dueDate: DateTime.now().add(Duration(days: 15)),
  ),
  Subscription(
    id: '',
    amount: 50.0,
    date: DateTime.now(),
    comments: "Monthly Netflix subscription",
    category: SubscriptionCategory.Streaming,
    dueDate: DateTime.now().add(Duration(days: 30)),
  ),
];
