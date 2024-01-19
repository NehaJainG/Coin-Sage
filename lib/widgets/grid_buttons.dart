import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/screens/user_rooms.dart';

class GridButtons extends StatelessWidget {
  const GridButtons({
    super.key,
    required this.addNewExpense,
    required this.addNewRoom,
  });

  final void Function(TransactionType type) addNewExpense;
  final void Function() addNewRoom;

  Widget getButtonWidget(Widget child) {
    return SizedBox(
      width: 175,
      height: 60,
      child: child,
    );
  }

  @override
  Widget build(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getButtonWidget(
              ElevatedButton.icon(
                onPressed: () {
                  addNewExpense(TransactionType.expense);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Expense'),
              ),
            ),
            getButtonWidget(
              ElevatedButton.icon(
                onPressed: () {
                  addNewExpense(TransactionType.income);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Income'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getButtonWidget(
              ElevatedButton.icon(
                onPressed: addNewRoom,
                icon: const Icon(Icons.add),
                label: const Text('Add new Room'),
              ),
            ),
            getButtonWidget(
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserRoomsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('View Rooms'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
