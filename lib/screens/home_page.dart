import 'package:flutter/material.dart';

import 'package:coin_sage/screens/add_new_room.dart';
import 'package:coin_sage/screens/add_new_transaction.dart';
import 'package:coin_sage/screens/user_rooms.dart';
import 'package:coin_sage/widgets/transaction_list.dart';
import 'package:coin_sage/widgets/quick_buttons.dart';
import 'package:coin_sage/widgets/statistics.dart';
import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/assets/icon.dart';

import 'package:coin_sage/data/expense_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  //final List<Transaction> userTransaction = transactionList;

  void _selectPage(int currentPageIndex) {
    //body
    setState(() {
      _selectedPage = currentPageIndex;
    });
  }

  void _addNewTransaction() async {
    final newTransaction = await Navigator.of(context).push<Transaction>(
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
  }

  void _addNewRoom() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      builder: (ctx) => const AddRoomScreen(),
    );
  }

  void _viewRooms() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => UserRoomsScreen(),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                QuickButtons(
                  newTransaction: _addNewTransaction,
                  newRoom: _addNewRoom,
                  allRooms: _viewRooms,
                ),
                const SizedBox(height: 15),
                TransactionStatistics(),
                const SizedBox(height: 15),
              ],
            ),
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
