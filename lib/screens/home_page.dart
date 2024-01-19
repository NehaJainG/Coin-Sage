import 'package:flutter/material.dart';

import 'package:coin_sage/screens/transaction_list.dart';
import 'package:coin_sage/screens/add_new_expense.dart';
import 'package:coin_sage/screens/add_new_room.dart';

import 'package:coin_sage/data/expense_list.dart';
import 'package:coin_sage/models/transaction.dart';

import 'package:coin_sage/widgets/grid_buttons.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final List<Transaction> userTransaction = transactionList;

  void _selectPage(int currentPageIndex) {
    //body
    setState(() {
      _selectedPage = currentPageIndex;
    });
  }

  void _addNewExpense(TransactionType newType) async {
    Transaction? newExpense = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(type: newType),
      ),
    );
    if (newExpense == null) return;
    setState(() {
      userTransaction.add(newExpense);
    });
  }

  void _addNewRoom() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddRoomScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          title: const Text('Heyy Neha!'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridButtons(
                addNewExpense: _addNewExpense,
                addNewRoom: _addNewRoom,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 14),
                child: Text(
                  'Your Transactions...',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Row(children: [
                TextButton(
                  child: Text('Filter 1'),
                  onPressed: () {},
                ),
                TextButton(
                  child: Text('Filter 2'),
                  onPressed: () {},
                ),
              ]),
              Expanded(
                  child: TransactionList(userTransaction: userTransaction)),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.onBackground,
          unselectedItemColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.60),
          iconSize: 26,
          currentIndex: _selectedPage,
          onTap: _selectPage,
          items: const [
            BottomNavigationBarItem(
              //tooltip: 'home',
              label: '.',
              icon: Icon(
                Icons.home_outlined,
              ),
              activeIcon: Icon(
                Icons.home_filled,
              ),
            ),
            BottomNavigationBarItem(
              label: '.',
              icon: Icon(
                Icons.stacked_bar_chart_rounded,
              ),
              activeIcon: Icon(
                Icons.bar_chart_rounded,
              ),
            ),
            BottomNavigationBarItem(
              label: '.',
              icon: Icon(
                Icons.account_balance_wallet_rounded,
              ),
            ),
            BottomNavigationBarItem(
              label: '.',
              icon: Icon(Icons.settings),
            ),
          ],
        ));
  }
}
