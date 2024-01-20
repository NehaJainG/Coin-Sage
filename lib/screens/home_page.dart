import 'package:flutter/material.dart';

import 'package:coin_sage/widgets/transaction_list.dart';
import 'package:coin_sage/widgets/grid_buttons.dart';
import 'package:coin_sage/screens/add_new_expense.dart';
import 'package:coin_sage/screens/add_new_room.dart';

import 'package:coin_sage/data/expense_list.dart';
import 'package:coin_sage/models/transaction.dart';

import 'package:coin_sage/assets/icon.dart';

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
        builder: (context) => AddExpenseScreen(),
      ),
    );
    if (newExpense == null) return;
    setState(() {
      userTransaction.add(newExpense);
    });
  }

  void _addNewRoom() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      builder: (ctx) => AddRoomScreen(),
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
          items: [
            BottomNavigationBarItem(
              //tooltip: 'home',
              label: '.',
              icon: homeIcon,
              activeIcon: homeActive,
            ),
            BottomNavigationBarItem(
              label: '.',
              icon: statistic,
              activeIcon: statisticActive,
            ),
            BottomNavigationBarItem(
              label: '.',
              icon: chat,
              activeIcon: chatActive,
            ),
            BottomNavigationBarItem(
              label: '.',
              icon: setting,
              activeIcon: settingActive,
            ),
          ],
        ));
  }
}
